//
//  EnemyBot.m
//  BurgerTime
//
//  Created by stanza on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "ParentEnemy.h"

@implementation ParentEnemy
@synthesize botType;
@synthesize hp;
@synthesize bot_atk, heart_atk;
@synthesize maxhp;
@synthesize trackingBots;

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

@end
