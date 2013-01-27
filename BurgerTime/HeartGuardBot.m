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
#import "PlaqueEnemy.h"
#import "Utils.h"

static NSArray *_botColors;

@implementation HeartGuardBot
@synthesize botType;
@synthesize level;
@synthesize range;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        botType = arc4random() % 5;
        // Probably not what we want to do.
        
        self.opaque = YES;
    }
    return self;
}

-(UIColor *)botColor  // color blind people are screwed
{
    switch(botType) {
        case SCRUB:
            return [UIColor blackColor];
        case PLUG:
            return [UIColor blueColor];
        case FIGHT:
            return [UIColor redColor];
        case HEALER:
            return [UIColor greenColor];
        case SPAWNBOT:
            return [UIColor yellowColor];
    }
    NSLog(@"Made it through color switch without picking a color");
    return [UIColor blackColor]; // removes warning
}

-(void)setBotImage {
    if (!_botColors)
        _botColors = [NSArray arrayWithObjects:@"white", @"blue", @"red", @"green", @"yellow", nil];
    UIImage *botImage = [UIImage imageNamed:[NSString stringWithFormat:@"nanobot_%@.png", [_botColors objectAtIndex:self.botType]]];
    [self addSubview:[[UIImageView alloc] initWithImage:botImage]];
}


- (void)interactWithEnemy:(EnemyBot *)enemy {
    switch (enemy.botType) {
        case TEAR: {
            CGFloat distance = [Utils distanceBetween:self.center and:enemy.center];
            if (distance < 75) {
                HeartLeakEnemy *leak = (HeartLeakEnemy*)enemy;
                if (self.enemyKey != leak) {
                    [self setDestinationPoint:[self randomPointWithinRect:enemy.frame]];
                    [leak track:self];
                }
            }
        }
            break;
        case PLAQUE: {
            CGFloat distance = [Utils distanceBetween:self.center and:enemy.center];
            if (distance < 75) {
                PlaqueEnemy *pe = (PlaqueEnemy*)enemy;
                if (self.enemyKey != pe) {
                    CGPoint p = [pe findASpreadPoint];
//                    [self setDestinationPoint:p];
                    [self orderCycleWithPivot:p radius:5];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (CGPoint)randomPointWithinRect:(CGRect)rect {
    return CGPointMake(rect.origin.x + arc4random()%(int)rect.size.width, rect.origin.y + arc4random()%(int)rect.size.height);
}

- (void)die {
    
}

@end
