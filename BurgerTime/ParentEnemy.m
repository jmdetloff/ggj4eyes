//
//  EnemyBot.m
//  BurgerTime
//
//  Created by stanza on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "ParentEnemy.h"
#import "HeartGuardBot.h"

@implementation ParentEnemy {
    NSInteger _attackTimer;
}

@synthesize botType;
@synthesize hp;
@synthesize bot_atk, heart_atk;
@synthesize maxhp;
@synthesize trackingBots;
@synthesize kill_reward;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        botType = arc4random() % 5;
        maxhp = 20;
        hp = maxhp;
//        atk = 20;
        self.trackingBots = [NSMutableArray array];
    }
    return self;
}

-(NSString *)name
{
    switch (botType) {
        case TEAR:
            return @"Myocardial rupture";
        case PLAQUE:
            return @"Atheromatous plaque";
        case PARASITE:
            return @"Toxoplasmosis";
        default:
            return nil;
    }
}
-(UIColor *)color
{
    switch(botType) {
        case TEAR:
            return [UIColor blackColor];
        case PARASITE:
            return [UIColor redColor];
        case PLAQUE:
            return [UIColor blueColor];

        default:
            return nil;
    }
}

- (void)destinationReached:(id)sender {
    // no-op
}

- (void)die {
    // noop
}

+(NSString*)nameFromType:(EnemyType)type {
    if (type == TEAR) {
        return @"Tear";
    } else if (type == PLAQUE) {
        return @"Plaque";
    } else if (type == PARASITE) {
        return @"Parasite";
    } else {
        return @"Should never get here.";
    }
}

- (void)attack {
    _attackTimer++;
    if (_attackTimer > 40) {
        _attackTimer = 0;
        [self.livingGuyManager livingGuy:self dealsHeartDamage:5];
    }
}

- (void)untrack:(HeartGuardBot *)bot {
    if ([self.trackingBots containsObject:bot]) {
        [self.trackingBots removeObject:bot];
        [bot clearDestination];
    }
}

@end
