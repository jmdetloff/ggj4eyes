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
}


- (id)initWithLevelParameters:(NSDictionary *)levelParameters {
    self = [super init];
    if (self) {
        
        _totalNanobots = [[NSMutableArray alloc] init];
        for (int i = 0; i < [levelParameters[@"startingBotNum"] intValue]; i++) {
            CGRect botFrame = CGRectMake(0, 0, 5, 5);
            botFrame.origin = [self randomPointWithinBounds];
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
    
    _moveTimer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(moveBots) userInfo:nil repeats:YES];
}


- (void)moveBots {
    
    for (HeartGuardBot *bot in _totalNanobots) {
        int direction = arc4random()%4;
        CGRect botFrame = bot.frame;
        switch (direction) {
            case 0:
                botFrame.origin.x--;
                break;
                
            case 1:
                botFrame.origin.x++;
                break;
            case 2:
                botFrame.origin.y++;
                break;
                
            case 3:
                botFrame.origin.y--;
                break;
            default:
                break;
        }
        bot.frame = botFrame;
    }
    
}


- (CGPoint)randomPointWithinBounds {
    return CGPointMake(arc4random()%1024, arc4random()%768);
}

@end
