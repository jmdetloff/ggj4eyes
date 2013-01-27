//
//  HeartLeakEnemy.m
//  BurgerTime
//
//  Created by John Detloff on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "HeartLeakEnemy.h"
#import "HeartGuardBot.h"
#import "LivingGuyManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation HeartLeakEnemy


- (id)initWithHP:(NSInteger)hp {
    self = [super init];
    if (self) {
        self.maxhp = hp;
        self.hp = hp;

        UIImageView *uiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rip_01.png"]];
        [self addSubview:uiv];
   //     self.backgroundColor = [UIColor whiteColor];
     //   self.layer.borderColor = [UIColor blackColor].CGColor;
       // self.layer.borderWidth = 3;
    }
    return self;
}


- (EnemyType)botType {
    return TEAR;
}


- (void)destinationReached:(id)sender {
    HeartGuardBot *bot = (HeartGuardBot *)sender;
    self.hp--;
    [self stainAtPoint:[self convertPoint:bot.frame.origin fromView:[self superview]]];
    [self.livingGuyManager livingGuy:self killsLivingGuy:bot];
    if (self.hp <= 0) {
        [self.livingGuyManager livingGuyDies:self];
    }
}


- (void)die {
    for (HeartGuardBot *bot in self.trackingBots) {
        if (bot.enemyKey == self) bot.enemyKey = nil;
    }
    [self.trackingBots removeAllObjects];
}


- (void)track:(HeartGuardBot *)bot {
    [self.trackingBots addObject:bot];
    bot.enemyKey = self;
}


- (void)stainAtPoint:(CGPoint)point {
    UIView *stain = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, 10, 10)];
    stain.backgroundColor = [UIColor redColor];
    stain.layer.cornerRadius = 5;
    stain.layer.masksToBounds = YES;
    [self addSubview:stain];
}

@end
