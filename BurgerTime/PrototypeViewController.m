//
//  PrototypeViewController.m
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "PrototypeViewController.h"
#import "HeartGuardBot.h"
#import "StaticDataManager.h"

@interface PrototypeViewController ()
@end


@implementation PrototypeViewController {
    NSMutableArray *_totalNanobots;
    NSTimer *_moveTimer;
    NSArray *_collidingRects;
    NSMutableArray *_nanobotsBeingSwiped;
    CGPoint _lastSwipePoint;
    NSTimer *_swipeTimer;
}


- (id)initWithLevelParameters:(NSDictionary *)levelParameters {
    self = [super init];
    if (self) {
        
        _collidingRects = @[[NSValue valueWithCGRect:CGRectMake(300, 300, 100, 100)]];
        
        _totalNanobots = [[NSMutableArray alloc] init];
        for (int i = 0; i < [levelParameters[@"startingBotNum"] intValue]; i++) {
            CGRect botFrame = CGRectMake(0, 0, 5, 5);
            botFrame.origin = [self randomPointWithinBoundsExcludingRects:_collidingRects];
            HeartGuardBot *bot = [[HeartGuardBot alloc] initWithFrame:botFrame];
            bot.backgroundColor = [bot botColor];
            [_totalNanobots addObject:bot];
        }
        
        _lastSwipePoint = CGPointMake(INFINITY, INFINITY);
        _nanobotsBeingSwiped = [[NSMutableArray alloc] init];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (HeartGuardBot *bot in _totalNanobots) {
        [self.view addSubview:bot];
    }
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    _moveTimer = [NSTimer scheduledTimerWithTimeInterval:1/30.0 target:self selector:@selector(moveBots) userInfo:nil repeats:YES];
    
    [[StaticDataManager sharedInstance] unpack];
}


- (void)moveBots {
    for (HeartGuardBot *bot in _totalNanobots) {
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
    
    for (HeartGuardBot *bot in _totalNanobots) {
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
};

@end
