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

@interface PrototypeViewController () <DeathDelegate>
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
}


- (id)initWithLevelParameters:(NSDictionary *)levelParameters {
    self = [super init];
    if (self) {
        
        _collidingRects = [CollidingRectsCreator collidingRectsForHeartWithScale:1];
        
        _livingGuyManager = [[LivingGuyManager alloc] init];
        _livingGuyManager.deathDelegate = self;
        
        CGRect spawnRect = CGRectMake(230, 550, 200, 300);
        
        for (int i = 0; i < [levelParameters[@"startingBotNum"] intValue]; i++) {
            CGRect botFrame = CGRectMake(0, 0, 5, 5);
            botFrame.origin = [self randomPointWithinBounds:spawnRect excludingRects:_collidingRects];
            HeartGuardBot *bot = [[HeartGuardBot alloc] initWithFrame:botFrame];
//            bot.backgroundColor = [bot botColor];
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
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart_bg.png"]];
    background.frame = self.view.bounds;
    [self.view addSubview:background];
    
    for (HeartGuardBot *bot in _livingGuyManager.bots) {
        [self.view addSubview:bot];
    }
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    _timeInterval = 1/30.0;
    _moveTimer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(moveBots) userInfo:nil repeats:YES];
    _rerollTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(rerollAllBots) userInfo:nil repeats:YES];
    [self rerollAllBots];
}


- (void)moveBots {
    for (HeartGuardBot *bot in [_livingGuyManager.bots copy]) {
        for (EnemyBot *enemy in _livingGuyManager.enemies) {
            [bot interactWithEnemy:enemy];
        }
        
//        NSArray *blockedDirections = [bot blockedDirectionsForBlockingRectangles:_collidingRects];
//        [bot moveWithBlockedDirections:blockedDirections];
    }
}

- (void)rerollAllBots {
    for (HeartGuardBot *bot in [_livingGuyManager.bots copy]) {
        [bot rerollAngle:_timeInterval];
    }
}


- (CGPoint)randomPointWithinBounds:(CGRect)rect excludingRects:(NSArray *)collidingRects {
    CGPoint randomPoint;
    BOOL verified = NO;
    while (!verified) {
        randomPoint = CGPointMake(rect.origin.x + arc4random()%(int)rect.size.width, rect.origin.y + arc4random()%(int)rect.size.height);
        BOOL invalid = NO;
        for (NSValue *collidingRectVal in collidingRects) {
            CGRect collidingRect = [collidingRectVal CGRectValue];
            if (CGRectContainsPoint(collidingRect, randomPoint)) {
                invalid = YES;
                break;
            }
        }
        if (!invalid) {
            verified = YES;
        }
    }
    return randomPoint;
}


- (void)swipe:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint stopLocation = [gestureRecognizer locationInView:self.view];
    
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
    
    for (HeartGuardBot *bot in _nanobotsBeingSwiped) {
        [bot setDestinationPoint:stopLocation withDuration:8];
    }
    
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
            botFrame.origin = [self randomPointWithinBounds:CGRectMake(200, 200, 200, 200) excludingRects:_collidingRects];
            enemy.frame = botFrame;
            enemy.livingGuyManager = _livingGuyManager;
            [self.view insertSubview:enemy atIndex:1];
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

@end
