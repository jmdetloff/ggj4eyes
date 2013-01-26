//
//  PrototypeViewController.m
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "PrototypeViewController.h"
#import "HeartGuardBot.h"

@interface PrototypeViewController ()
@end


@implementation PrototypeViewController {
    NSMutableArray *_totalNanobots;
    NSTimer *_moveTimer;
    NSArray *_collidingRects;
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
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (HeartGuardBot *bot in _totalNanobots) {
        [self.view addSubview:bot];
    }
    
    _moveTimer = [NSTimer scheduledTimerWithTimeInterval:1/30.0 target:self selector:@selector(moveBots) userInfo:nil repeats:YES];
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

@end
