//
//  PrototypeViewController.m
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "PrototypeViewController.h"
#import "HeartGuardBot.h"
#import "ParentEnemy.h"
#import "EnemySpawner.h"
#import "LivingGuyManager.h"
#import "CollidingRectsCreator.h"
#import "MovingCollidingGuy.h"
#import "PanlessScrollView.h"
#import "AudioManagement.h"
#import "Utils.h"
#import "StaticDataManager.h"
#import "ZapView.h"
#import "Level.h"
#import "Wave.h"
#import "Nanobot.h"
#import "InfoPanel.h"
#import "DefeatView.h"
#import "VictoryView.h"

#define kPowerRadius 80
#define kFullHealth 5000
#define kFullHealthbarLength 95

@interface PrototypeViewController () <DeathDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>
@end


@implementation PrototypeViewController {
    NSDictionary *_levelParams;
    NSTimer *_moveTimer;
    NSTimer *_rerollTimer;
    
    Level *_curLevel;
    NSTimer *_waveTimer;
    int _waveCtr;
    double _waveTimeElapsed;
    
    NSArray *_collidingRects;
    NSMutableArray *_nanobotsBeingSwiped;
    CGPoint _lastSwipePoint;
    NSTimer *_enemySpawnTimer;
    NSInteger _currentWave;
    LivingGuyManager *_livingGuyManager;
    double _timeInterval;
    BOOL _currentSwipeValid;
    PanlessScrollView *_pinchView;
    UIView *_zoomingContentView;
    UIView *_gestureView;
    UIView *_draggingView;
    NSArray *_buttons;
    UIView *_descriptionView;
    InfoPanel *_infoPanel;
    UILabel *_fightCount;
    NSInteger _fattyHealth;
    UIView *_healthBar;
    BOOL _gameOver;
}


- (id)initWithLevelParameters:(NSDictionary *)levelParameters {
    self = [super init];
    if (self) {
        _fattyHealth = kFullHealth;
        
        //scaleFactor = [[UIScreen mainScreen] bounds].size.width / 768;  // This should work but for sanity we should use
        scaleFactor = 1;

        //load static data from json
        [[StaticDataManager sharedInstance] unpack];
        
        _levelParams = levelParameters;
        
        _collidingRects = [CollidingRectsCreator collidingRectsForHeartWithScale:scaleFactor];
        
        _livingGuyManager = [[LivingGuyManager alloc] init];
        _livingGuyManager.deathDelegate = self;
        
        _lastSwipePoint = CGPointMake(INFINITY, INFINITY);
        _nanobotsBeingSwiped = [[NSMutableArray alloc] init];
        
//        _enemySpawnTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(spawnEnemyWave) userInfo:nil repeats:NO]; // should repeat later
        
        [self loadLevel:0];
    }
    return self;
}


- (void)viewWasBornAtPoint:(CGPoint)point {
    [self spawnHeartGuardAtPoint:point];
}

- (void)spawnHeartGuardAtPoint:(CGPoint)point {
    CGRect botFrame = CGRectMake(0, 0, 5, 5);
    botFrame.origin = point;
    HeartGuardBot *bot = [[HeartGuardBot alloc] initWithFrame:botFrame];
    bot.livingGuyManager = _livingGuyManager;
    [_livingGuyManager.bots addObject:bot];
    [_zoomingContentView addSubview:bot];
    _infoPanel.neutralCount++;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _infoPanel = [[InfoPanel alloc] initWithFrame:CGRectMake(32, 900, 245, 92)];
    
    _pinchView = [[PanlessScrollView alloc] initWithFrame:self.view.bounds];
    _pinchView.minimumZoomScale = 1;
    _pinchView.maximumZoomScale = 2;
    _pinchView.contentSize = self.view.frame.size;
    _pinchView.delegate = self;
    [_pinchView setBouncesZoom:NO];
    [_pinchView setBounces:NO];
    [self.view addSubview:_pinchView];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    background.frame = self.view.bounds;
    _zoomingContentView = background;
    [_pinchView addSubview:_zoomingContentView];
   
    scaleFactor = [[UIScreen mainScreen] bounds].size.width / 768;
 
    NSArray *spawningRects = [CollidingRectsCreator validSpawningLocationsWithScale:scaleFactor];
    for (int i = 0; i < [_levelParams[@"startingBotNum"] intValue]; i++) {
        [self spawnHeartGuardAtPoint:[self randomPointWithinRects:spawningRects]];
    }
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    _timeInterval = 1/30.0;
    _moveTimer = [NSTimer timerWithTimeInterval:_timeInterval target:self selector:@selector(moveBots) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_moveTimer forMode:NSRunLoopCommonModes];
    _rerollTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(rerollAllBots) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_rerollTimer forMode:NSRunLoopCommonModes];
    [self rerollAllBots];
    
    CGFloat panelHeight = 100;
    UIView *toolPanelView = [[UIView alloc] initWithFrame:CGRectMake(0, 900, 768, panelHeight)];
    toolPanelView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:toolPanelView];
    
    CGSize buttonSize = CGSizeMake(92, 92);
    
    UIImageView *fightButton = [[UIImageView alloc] initWithFrame:CGRectMake(300, 0, buttonSize.width, buttonSize.height)];
    [fightButton setImage:[UIImage imageNamed:@"FightButton.png"]];
    fightButton.tag = FIGHT;
    [toolPanelView addSubview:fightButton];
    
    UIImageView *healButton = [[UIImageView alloc] initWithFrame:CGRectMake(414, 0, buttonSize.width, buttonSize.height)];
    [healButton setImage:[UIImage imageNamed:@"HealButton.png"]];
    healButton.tag = HEALER;
    [toolPanelView addSubview:healButton];
    
    UIImageView *cleanButton = [[UIImageView alloc] initWithFrame:CGRectMake(528, 0, buttonSize.width, buttonSize.height)];
    [cleanButton setImage:[UIImage imageNamed:@"CleanButton.png"]];
    cleanButton.tag = SCRUB;
    [toolPanelView addSubview:cleanButton];
    
    UIImageView *momButton = [[UIImageView alloc] initWithFrame:CGRectMake(643, 0, buttonSize.width, buttonSize.height)];
    [momButton setImage:[UIImage imageNamed:@"MomButton.png"]];
    momButton.tag = SPAWNBOT;
    [toolPanelView addSubview:momButton];
    
    _buttons = @[fightButton, healButton, cleanButton, momButton];
    [[AudioManagement sharedInstance] playBackground];
    
    [self.view addSubview:[ZapView sharedInstance]];
    
    NSInteger level = [_levelParams[@"levelNum"] intValue];
    UIImageView *portrait = [[UIImageView alloc] initWithFrame:CGRectMake(548, 32, 187, 218)];
    portrait.image = [UIImage imageNamed:[NSString stringWithFormat:@"Level%iPortrait.png",level]];
    [self.view addSubview:portrait];
    
    [self.view addSubview:_infoPanel];
    
    _healthBar = [[UIView alloc] initWithFrame:CGRectMake(622, 219, 95, 12)];
    _healthBar.backgroundColor = [UIColor colorWithRed:83/255.f green:249/255.f blue:99/255.f alpha:1];
    [self.view addSubview:_healthBar];
}

- (void)dealHeartDamage:(int)damage {
    if (_gameOver) return;
    
    _fattyHealth -= damage;
    CGFloat percentHealth = _fattyHealth/(CGFloat)kFullHealth;
    CGRect frame = _healthBar.frame;
    frame.size.width = percentHealth*kFullHealthbarLength;
    _healthBar.frame = frame;
    
    if (_fattyHealth <= 0) {
        [self loseGame];
    }
}

- (void)startDragging:(UIView *)sender {
    NanabotType type = sender.tag;
    switch (type) {
        case FIGHT:
            _draggingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FightDrag.png"]];
            //[[AudioManagement sharedInstance] playZapper];
            break;
            
        case SCRUB:
            _draggingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CleanDrag.png"]];
            //[[AudioManagement sharedInstance] playCleaning];
            break;
            
        case SPAWNBOT:
            _draggingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MomDrag.png"]];
            //[[AudioManagement sharedInstance] playMombo];
            break;
            
        case HEALER:
            _draggingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HealDrag.png"]];
            //[[AudioManagement sharedInstance] playCloth];
            break;
            
        default:
            break;
    }
    
    _draggingView.tag = sender.tag;
    _draggingView.center = CGPointMake(sender.frame.origin.x + 92/2, 900 + 92/2);
    [self.view addSubview:_draggingView];
    _pinchView.userInteractionEnabled = NO;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (_draggingView || _gameOver) {
        return NO;
    } else {
        for (UIView *view in _buttons) {
            CGPoint loc = [touch locationInView:view];
            if (CGRectContainsPoint(view.bounds, loc)) {
                return NO;
            }
        }
        return YES;
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_gameOver)return;
    
    UITouch *touch = [touches anyObject];
    for (UIView *view in _buttons) {
        CGPoint loc = [touch locationInView:view];
        if (CGRectContainsPoint(view.bounds, loc)) {
            [self startDragging:view];
            break;
        }
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_gameOver)return;
    
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    _draggingView.center = loc;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_gameOver)return;
    
    UITouch *touch = [touches anyObject];

    UIView *tappedButton = nil;
    
    if (_descriptionView && !_draggingView) {
        [_descriptionView removeFromSuperview];
        _descriptionView = nil;
        [[AudioManagement sharedInstance] playInfoClose];
    }
    
    for (UIView *button in _buttons) {
        CGPoint loc = [touch locationInView:button];
        if (CGRectContainsPoint(button.bounds, loc)) {
            tappedButton = button;
            break;
        }
    }
    
    if (!tappedButton) {
        if (_draggingView) {
            CGPoint loc = [touch locationInView:_zoomingContentView];
            [self transformBotsToType:_draggingView.tag atPoint:loc];
        }
        if (!_descriptionView) {
            _pinchView.userInteractionEnabled = YES;
        }
    } else {
        [self tappedButton:tappedButton];
    }
    
    [_draggingView removeFromSuperview];
    _draggingView = nil;
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"cancelled");
}


- (void)moveBots {
    for (HeartGuardBot *bot in [_livingGuyManager.bots copy]) {
        for (ParentEnemy *enemy in [_livingGuyManager.enemies copy]) {
            [bot interactWithEnemy:enemy];
        }
        [bot doAction];
        [bot advance:_timeInterval];
    }
    for (ParentEnemy *enemy in [_livingGuyManager.enemies copy]) {
        [enemy advance:_timeInterval];
        [enemy attack];
    }
}

- (void)rerollAllBots {
    for (HeartGuardBot *bot in [_livingGuyManager.bots copy]) {
        [bot rerollAngle:_timeInterval];
    }
}


- (CGPoint)randomPointWithinRects:(NSArray *)rects {
    NSValue *randVal = [rects objectAtIndex:arc4random()%[rects count]];
    CGRect rect = [randVal CGRectValue];
    return CGPointMake(rect.origin.x + arc4random()%(int)rect.size.width, rect.origin.y + arc4random()%(int)rect.size.height);
}



- (void)swipe:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint stopLocation = [gestureRecognizer locationInView:_zoomingContentView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _currentSwipeValid = YES;
    }
    
    if (![CollidingRectsCreator validPos:stopLocation]) {
        _currentSwipeValid = NO;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        _lastSwipePoint = CGPointMake(INFINITY, INFINITY);
        
        NSTimer *swipeTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(freeSwipedBots:) userInfo:[_nanobotsBeingSwiped copy] repeats:NO];
        for (HeartGuardBot *bot in _nanobotsBeingSwiped) {
            bot.swipeKey = swipeTimer;
        }
        
        [_nanobotsBeingSwiped removeAllObjects];
        if(!arc4random() % 5)   {[[AudioManagement sharedInstance] playRobotDamage];}
        return;
    }
    
    if ([Utils distanceBetween:_lastSwipePoint and:stopLocation] < 60) {
        return;
    }
    
    for (HeartGuardBot *bot in _livingGuyManager.bots) {
        if ([Utils distanceBetween:stopLocation and:bot.center] < 60) {
            if (![_nanobotsBeingSwiped containsObject:bot]) {
                [_nanobotsBeingSwiped addObject:bot];
                bot.swipeKey = nil;
            }
        }
    } 
    
    if (_currentSwipeValid) {
        for (HeartGuardBot *bot in _nanobotsBeingSwiped) {
            [bot setDestinationPoint:stopLocation];
        }
    }
    
    if (_currentSwipeValid)
        _lastSwipePoint = stopLocation;
}


- (void)freeSwipedBots:(NSTimer *)timer {
    for (HeartGuardBot *bot in timer.userInfo) {
        if (bot.swipeKey == timer) {
            [bot clearDestination];
        }
    }
}

//- (void)spawnEnemyWave {
//    ParentEnemy *firstBot = [EnemySpawner createEnemyForType:PARASITE];
//    [self placeEnemy:firstBot];
//}

- (void)spawnSpecificWave:(int)wave_id {
    Wave *w = [StaticDataManager objectOfType:@"wave" atIndex:wave_id];
//    EnemyType et = 0;
//    if ([w.enemy_type isEqualToString:@"Tear"])
//        et = TEAR;
//    else if ([w.enemy_type isEqualToString:@"Plaque"])
//        et = PLAQUE;
//    else if ([w.enemy_type isEqualToString:@"Parasite"])
//        et = PARASITE;
    NSLog(@"t=%f Placing enemy: %@", _waveTimeElapsed, w.enemy_type);
    ParentEnemy *firstBot = [EnemySpawner createEnemyForWave:w];
    [self placeEnemy:firstBot];
}

- (void)notifyLevelDone {
    //dunno what you want here...
}

- (void)spawnEnemyWaveByTime {
    _waveTimeElapsed += 1;
    while (1) {
        if (_waveCtr >= [_curLevel.wave_ids count]) {
            [_waveTimer invalidate];
            _waveTimer = nil;
            [self notifyLevelDone];
            break;
        }
        NSNumber *n = [_curLevel.wave_times objectAtIndex:_waveCtr];
        if (_waveTimeElapsed < [n intValue]) {
            break;
        } else {
            int wid = [[_curLevel.wave_ids objectAtIndex:_waveCtr] intValue];
            [self spawnSpecificWave:wid];
             _waveCtr++;
        }
    }
}

- (void)loadLevel:(int)level {
    _curLevel = [StaticDataManager objectOfType:@"level" atIndex:level];
    _waveCtr = 0;
    _waveTimeElapsed = 0;
    _waveTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(spawnEnemyWaveByTime) userInfo:nil repeats:YES];
}

- (void)placeEnemy:(ParentEnemy *)enemy {
    NSArray *spawnRects = [CollidingRectsCreator validSpawningLocationsWithScale:scaleFactor];
    CGPoint p = [self randomPointWithinRects:spawnRects];
    enemy.frame = CGRectMake(p.x, p.y, enemy.frame.size.width, enemy.frame.size.height);
    enemy.livingGuyManager = _livingGuyManager;
    [_zoomingContentView insertSubview:enemy atIndex:1];
    [_livingGuyManager.enemies addObject:enemy];
}


- (void)viewDied:(UIView *)view {
    if ([view isKindOfClass:[ParentEnemy class]]) {
        _infoPanel.points += ((ParentEnemy*)view).kill_reward;
    }
    if ([view isKindOfClass:[HeartGuardBot class]]) {
        HeartGuardBot *bot = (HeartGuardBot *)view;
        [self incrementType:bot.nanobotType by:-1];
        
        if (_infoPanel.fighterCount + _infoPanel.healCount + _infoPanel.cleanerCount + _infoPanel.neutralCount <= 0) {
            [self loseGame];
        }
    }
    [view removeFromSuperview];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _zoomingContentView;
}


- (void)incrementType:(NanabotType)type by:(int)incrementer {
    switch (type) {
        case FIGHT:
            _infoPanel.fighterCount+=incrementer;
            break;
        case SCRUB:
            _infoPanel.cleanerCount+=incrementer;
            break;
        case HEALER:
            _infoPanel.healCount+=incrementer;
            break;
        default:
            break;
    }
}


- (void)transformBotsToType:(NanabotType)type atPoint:(CGPoint)loc {
    Nanobot *nb = [StaticDataManager objectOfType:@"nanobot" atIndex:type];
    if (_infoPanel.points >= nb.cost) {
        _infoPanel.points -= nb.cost;
    } else {
        //not enough cash
        return;
    }
    
    bool flag = false;
    for (HeartGuardBot *bot in _livingGuyManager.bots) {
        if ([Utils distanceBetween:bot.center and:loc] < kPowerRadius) {
            flag = true;
            if (bot.nanobotType != SPAWNBOT) {
                [self incrementType:bot.nanobotType by:-1];
                bot.nanobotType = type;
                [self incrementType:type by:1];
                if (type == SPAWNBOT) {
                    break;
                }
            }
        }
    }
    // Play audio here
    switch (type)
    {
        case SCRUB:
            [[AudioManagement sharedInstance] playCleaning];
            break;
        case SPAWNBOT:
            [[AudioManagement sharedInstance] playMombo];
            break;
        case HEALER:
            [[AudioManagement sharedInstance] playCloth];
            break;
        case FIGHT:
            [[AudioManagement sharedInstance] playZapper];
            break;
        default:
            break;
    }
    
}


- (void)tappedButton:(UIView *)button {
    [_descriptionView removeFromSuperview];
    
    NanabotType type = button.tag;
    switch (type) {
        case FIGHT:
            _descriptionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FighterDescription.png"]];
            [[AudioManagement sharedInstance] playInfoOpen];
            break;
            
        case SCRUB:
            _descriptionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CleanerDescription.png"]];
            [[AudioManagement sharedInstance] playInfoOpen];
            break;
            
        case SPAWNBOT:
            _descriptionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MomDescription.png"]];
            [[AudioManagement sharedInstance] playInfoOpen];
            break;
            
        case HEALER:
            _descriptionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HealerDescription.png"]];
            [[AudioManagement sharedInstance] playInfoOpen];
            break;
            
        default:
            break;
    }
    
    _descriptionView.tag = button.tag;
    _descriptionView.center = CGPointMake(button.frame.origin.x + 92/2, 900 - 140 );
    [self.view addSubview:_descriptionView];
}

- (void)loseGame {
    _gameOver = YES;
    
    DefeatView *defeatView = [[DefeatView alloc] initWithFrame:CGRectMake(33, 285, 702, 561) forLevel:[_levelParams[@"levelNum"] intValue]];
    [self.view addSubview:defeatView];
}


- (void)winGame {
    _gameOver = YES;
    VictoryView *victoryView = [[VictoryView alloc] initWithFrame:CGRectMake(33, 285, 702, 561) forLevel:[_levelParams[@"levelNum"] intValue]];
    [self.view addSubview:victoryView];
}

@end
