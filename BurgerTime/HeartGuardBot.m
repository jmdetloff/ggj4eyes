//
//  HeartGuardBot.m
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "HeartGuardBot.h"
#import "HeartLeakEnemy.h"
#import <QuartzCore/QuartzCore.h>

static NSArray *_botColors;

@implementation HeartGuardBot
@synthesize botType;
@synthesize level;
@synthesize range;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        botType = STANDARD;
        
        self.opaque = YES;
    }
    return self;
}

-(void)setBotImage {
    if (!_botColors)
        _botColors = [NSArray arrayWithObjects:@"white", @"blue", @"red", @"green", @"yellow", nil];
    UIImage *botImage = [UIImage imageNamed:[NSString stringWithFormat:@"nanobot_%@.png", [_botColors objectAtIndex:self.botType]]];
    [self addSubview:[[UIImageView alloc] initWithImage:botImage]];
}


- (void)setNanobotType:(NanabotType)nanobotType {
    _nanobotType = nanobotType;
    [self setBotImage];
}


- (void)interactWithEnemy:(EnemyBot *)enemy {
    switch (enemy.botType) {
        case TEAR: {
            CGFloat distance = [self distanceBetween:self.center and:enemy.center];
            if (distance < 75) {
                HeartLeakEnemy *leak = (HeartLeakEnemy*)enemy;
                if (self.enemyKey != leak) {
                    [self setDestinationPoint:[self randomPointWithinRect:enemy.frame] withDuration:-1];
                    [leak track:self];
                }
            }
        }
            break;
            
        default:
            break;
    }
}


- (CGFloat) distanceBetween:(CGPoint)point1 and:(CGPoint)point2 {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy);
}


- (CGPoint)randomPointWithinRect:(CGRect)rect {
    return CGPointMake(rect.origin.x + arc4random()%(int)rect.size.width, rect.origin.y + arc4random()%(int)rect.size.height);
}

- (void)die {
    
}

@end
