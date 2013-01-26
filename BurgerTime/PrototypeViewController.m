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

@interface PrototypeViewController () <DeathDelegate>
@end


@implementation PrototypeViewController {
    NSTimer *_moveTimer;
    NSArray *_collidingRects;
    NSMutableArray *_nanobotsBeingSwiped;
    CGPoint _lastSwipePoint;
    NSTimer *_enemySpawnTimer;
    NSInteger _currentWave;
    LivingGuyManager *_livingGuyManager;
}


- (id)initWithLevelParameters:(NSDictionary *)levelParameters {
    self = [super init];
    if (self) {
        
        _collidingRects = @[[NSValue valueWithCGRect:CGRectMake(-10, -10, 20, 788)],
                            [NSValue valueWithCGRect:CGRectMake(1014, -10, 20, 788)],
                            [NSValue valueWithCGRect:CGRectMake(-10, -10, 1044, 20)],
                            [NSValue valueWithCGRect:CGRectMake(-10, 738, 1044, 20)]];
        
        _livingGuyManager = [[LivingGuyManager alloc] init];
        _livingGuyManager.deathDelegate = self;
        
        for (int i = 0; i < [levelParameters[@"startingBotNum"] intValue]; i++) {
            CGRect botFrame = CGRectMake(0, 0, 5, 5);
            botFrame.origin = [self randomPointWithinBoundsExcludingRects:_collidingRects];
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
    
    for (HeartGuardBot *bot in _livingGuyManager.bots) {
        [self.view addSubview:bot];
    }
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    _moveTimer = [NSTimer scheduledTimerWithTimeInterval:1/30.0 target:self selector:@selector(moveBots) userInfo:nil repeats:YES];
}


- (void)moveBots {
    for (HeartGuardBot *bot in [_livingGuyManager.bots copy]) {
        for (EnemyBot *enemy in _livingGuyManager.enemies) {
            [bot interactWithEnemy:enemy];
        }
        
        NSArray *blockedDirections = [bot blockedDirectionsForBlockingRectangles:_collidingRects];
        [bot moveWithBlockedDirections:blockedDirections];
    }
}


- (CGPoint)randomPointWithinBoundsExcludingRects:(NSArray *)collidingRects {
    CGPoint randomPoint;
    BOOL verified = NO;
    while (!verified) {
        randomPoint = CGPointMake(arc4random()%1024, arc4random()%768);
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
            botFrame.origin = [self randomPointWithinBoundsExcludingRects:_collidingRects];
            enemy.frame = botFrame;
            enemy.livingGuyManager = _livingGuyManager;
            [self.view insertSubview:enemy atIndex:0];
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
