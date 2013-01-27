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

@implementation HeartGuardBot {
    int _actionCounter;
}
@synthesize level;
@synthesize range;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nanobotType = STANDARD;
        
        self.opaque = YES;
    }
    return self;
}

-(void)setBotImage {
    if (!_botColors)
        _botColors = [NSArray arrayWithObjects:@"Neutral", @"Cleaner", @"Healer", @"Mom", @"Fighter", nil];
    UIImage *botImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@bot.png", [_botColors objectAtIndex:self.nanobotType]]];
    for (UIView *subview in [[self subviews] copy]) {
        [subview removeFromSuperview];
    }
    [self addSubview:[[UIImageView alloc] initWithImage:botImage]];
}


- (void)setNanobotType:(NanabotType)nanobotType {
    _actionCounter = 0;
    _nanobotType = nanobotType;
    [self setBotImage];
}


- (void)interactWithEnemy:(ParentEnemy *)enemy {
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
                    [self orderCycleWithPivot:p radius:10];
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


- (void)doAction {
    switch (self.nanobotType) {
        case SPAWNBOT: {
            if (_actionCounter > 50) {
                _actionCounter = 0;
                [self.livingGuyManager livingGuyReproduces:self];
            }
        }
        break;
            
        default:
            break;
    }
    
    _actionCounter++;
}

@end
