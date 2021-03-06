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
#import "ParasiteEnemy.h"
#import "ZapView.h"
#import "ParentEnemy.h"
#import "Nanobot.h"
#import "StaticDataManager.h"
#import "PrototypeViewController.h"

static NSArray *_botColors;

@implementation HeartGuardBot {
    int _actionCounter;
    int _maxMomCount;
}
@synthesize level;
@synthesize range;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nanobotType = STANDARD;
        self.layer.masksToBounds = NO;
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
    
    if (_nanobotType == SPAWNBOT)
        _maxMomCount = kMaxMomSpawn;
}

- (int)damageAgainst:(ParentEnemy*)enemy {
    Nanobot *nb = [StaticDataManager objectOfType:@"nanobot" atIndex:self.nanobotType];
    EnemyType et = enemy.botType;
    NSString *tn = [ParentEnemy nameFromType:et];
    NSNumber *bonus = [nb.modifiers objectForKey:tn];
    if (bonus) {
        return nb.atk + [bonus intValue];
    } else {
        return nb.atk;
    }
}

- (void)interactWithEnemy:(ParentEnemy *)enemy {
    CGFloat distance = [Utils distanceBetween:self.center and:enemy.center];
    
    switch (enemy.botType) {
        case TEAR: {
            if (distance < 75) {
                HeartLeakEnemy *leak = (HeartLeakEnemy*)enemy;
                if (self.enemyKey != leak) {
                    if ([self setOptionalDestinationPoint:[self randomPointWithinRect:enemy.frame]]) {
                        [leak track:self];
                    }
//                    [self setDestinationPoint:[self randomPointWithinRect:enemy.frame]];

                }
            }
        }
            break;
        case PLAQUE: {
            if (distance < 75) {
                PlaqueEnemy *pe = (PlaqueEnemy*)enemy;
                if (self.enemyKey != pe && pe.hp > 0) {
                    CGPoint p = [pe findASpreadPoint];
                    //mdsa - stupid hack
                    p = CGPointMake(p.x - 10, p.y - 10);
                    //end hack
                    [self orderCycleWithPivot:p radius:10];
                    [pe track:self];
                }
            }
        }
            break;
        case PARASITE: {
            ParasiteEnemy *parasite = (ParasiteEnemy *)enemy;
            if (distance < 20) {
                if (self == parasite.victim) parasite.victim = nil;
                [self.livingGuyManager livingGuy:enemy killsLivingGuy:self];
            } else if (distance < 70) {
                if (parasite.victim == nil || (self.nanobotType == SPAWNBOT && parasite.victim.nanobotType != SPAWNBOT)) {
                    parasite.victim = self;
                }
            }
            
            if (self.nanobotType == FIGHT && distance < 70) {
                if (_actionCounter > 50) {
                    [self zapEnemy:parasite];
                    _actionCounter = 0;
                }
            }
        }
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
                _maxMomCount--;
                [self.livingGuyManager livingGuyReproduces:self];
                if (_maxMomCount == 0)
                    [self.livingGuyManager livingGuyDies:self];
            }
        }
        break;
            
        default:
            break;
    }
    
    _actionCounter++;
}


- (void)zapEnemy:(ParasiteEnemy *)enemy {
    [enemy zap:self];
    [[ZapView sharedInstance] displayZapFrom:self.center to:enemy.center];
}


@end
