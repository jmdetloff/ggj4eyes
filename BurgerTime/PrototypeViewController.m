//
//  PrototypeViewController.m
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "PrototypeViewController.h"
#import "HeartGuardBot.h"
#import "EnemyBot.h"
#import "EnemySpawner.h"
#import "LivingGuyManager.h"
#import "CollidingRectsCreator.h"
#import "MovingCollidingGuy.h"
#import "PanlessScrollView.h"

#define kPowerRadius 80

@interface PrototypeViewController () <DeathDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>
@end


@implementation PrototypeViewController {
    NSTimer *_moveTimer;
    NSTimer *_rerollTimer;
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
}


- (id)initWithLevelParameters:(NSDictionary *)levelParameters {
    self = [super init];
    if (self) {
        
        _collidingRects = [CollidingRectsCreator collidingRectsForHeartWithScale:1];
        
        _livingGuyManager = [[LivingGuyManager alloc] init];
        _livingGuyManager.deathDelegate = self;
        
        NSArray *spawningRects = [CollidingRectsCreator validSpawningLocationsWithScale:1];
        for (int i = 0; i < [levelParameters[@"startingBotNum"] intValue]; i++) {
            CGRect botFrame = CGRectMake(0, 0, 5, 5);
            botFrame.origin = [self randomPointWithinRects:spawningRects];
            HeartGuardBot *bot = [[HeartGuardBot alloc] initWithFrame:botFrame];
            [bot setBotImage];
            bot.livingGuyManager = _livingGuyManager;
            [_livingGuyManager.bots addObject:bot];
        }
        
        _lastSwipePoint = CGPointMake(INFINITY, INFINITY);
        _nanobotsBeingSwiped = [[NSMutableArray alloc] init];
        
        _enemySpawnTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(spawnEnemyWave) userInfo:nil repeats:NO]; // should repeat later
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    for (HeartGuardBot *bot in _livingGuyManager.bots) {
        [_zoomingContentView addSubview:bot];
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
}

- (void)startDragging:(UIView *)sender {
    NanabotType type = sender.tag;
    switch (type) {
        case FIGHT:
            _draggingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FightDrag.png"]];
            break;
            
        case SCRUB:
            _draggingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CleanDrag.png"]];
            break;
            
        case SPAWNBOT:
            _draggingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MomDrag.png"]];
            break;
            
        case HEALER:
            _draggingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HealDrag.png"]];
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
    if (_draggingView) {
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
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    _draggingView.center = loc;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:_zoomingContentView];
    
    [self transformBotsToType:_draggingView.tag atPoint:loc];
    
    [_draggingView removeFromSuperview];
    _draggingView = nil;
    _pinchView.userInteractionEnabled = YES;
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"cancelled");
}


- (void)moveBots {
    for (HeartGuardBot *bot in [_livingGuyManager.bots copy]) {
        for (EnemyBot *enemy in _livingGuyManager.enemies) {
            [bot interactWithEnemy:enemy];
        }
        [bot advance:_timeInterval];
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
    
    if (![MovingCollidingGuy validPos:stopLocation]) {
        _currentSwipeValid = NO;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        _lastSwipePoint = CGPointMake(INFINITY, INFINITY);
        
        NSTimer *swipeTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(freeSwipedBots:) userInfo:[_nanobotsBeingSwiped copy] repeats:NO];
        for (HeartGuardBot *bot in _nanobotsBeingSwiped) {
            bot.swipeKey = swipeTimer;
        }
        
        [_nanobotsBeingSwiped removeAllObjects];
        
        return;
    }
    
    if ([self distanceBetween:_lastSwipePoint and:stopLocation] < 60) {
        return;
    }
    
    for (HeartGuardBot *bot in _livingGuyManager.bots) {
        if ([self distanceBetween:stopLocation and:bot.center] < 60) {
            if (![_nanobotsBeingSwiped containsObject:bot]) {
                [_nanobotsBeingSwiped addObject:bot];
                bot.swipeKey = nil;
            }
        }
    } 
    
    if (_currentSwipeValid) {
        for (HeartGuardBot *bot in _nanobotsBeingSwiped) {
            [bot setDestinationPoint:stopLocation withDuration:8];
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


- (CGFloat) distanceBetween:(CGPoint)point1 and:(CGPoint)point2 {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy);
}


- (void)spawnEnemyWave {
    EnemyBot *firstBot = [EnemySpawner createEnemyForType:TEAR];
    [self placeEnemy:firstBot];
}


- (void)placeEnemy:(EnemyBot *)enemy {
    switch (enemy.botType) {
        case TEAR: {
            CGRect botFrame = CGRectMake(0, 0, 20, 100);
            NSArray *spawnRects = [CollidingRectsCreator validSpawningLocationsWithScale:1];
            botFrame.origin = [self randomPointWithinRects:spawnRects];
            enemy.frame = botFrame;
            enemy.livingGuyManager = _livingGuyManager;
            [_zoomingContentView insertSubview:enemy atIndex:1];
        }
        break;
            
        default:
            break;
    }
    
    [_livingGuyManager.enemies addObject:enemy];
}


- (void)viewDied:(UIView *)view {
    [view removeFromSuperview];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _zoomingContentView;
}

- (void)transformBotsToType:(NanabotType)type atPoint:(CGPoint)loc {
    for (HeartGuardBot *bot in _livingGuyManager.bots) {
        if ([self distanceBetween:bot.center and:loc] < kPowerRadius) {
            bot.nanobotType = type;
            if (type == SPAWNBOT) break;
        }
    }
}

@end
