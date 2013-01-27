//
//  PlaqueEnemy.m
//  BurgerTime
//
//  Created by Michel D'Sa on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "PlaqueEnemy.h"
#import "Utils.h"
#import "CollidingRectsCreator.h"
#import "ParentEnemy.h"
#import "HeartGuardBot.h"

static const float _sideLength = 40;

@implementation PlaqueEnemy

@synthesize plaqueView, spreadPoints, numSpreadPoints, megaTimer;

- (id)initWithHP:(int)hp_ spreadRadius:(float)sr_ {
    self = [super init];
    if (self) {
//        self.position = position_;
        self.maxhp = hp_;
        self.hp = hp_;
        self.botType = PLAQUE;
        
        //randomly pick a plaque image
        NSString *plaqueImageName = [NSString stringWithFormat:@"_plaqu%02d.png", arc4random()%3 + 1];
        self.plaqueView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:plaqueImageName]];
        [self addSubview:self.plaqueView];
        self.frame = CGRectMake(0,
                                0,
                                _sideLength,
                                _sideLength);
//        self.plaqueView.frame = CGRectMake(0,
//                                           0,
//                                           _sideLength,
//                                           _sideLength);
//        self.plaqueView.center = CGPointMake(_sideLength/2, _sideLength/2);
        
        self.numSpreadPoints = 4;
        
        //randomly pick 4 "scrub points" within the spread radius
        int i = self.numSpreadPoints;
        self.spreadPoints = [NSMutableArray array];
        while (i > 0) {
            float x = [Utils randomFloatBetween:-sr_/2 And:sr_/2];
            float y = [Utils randomFloatBetween:-sr_/2 And:sr_/2];
            if (x*x + y*y <= sr_*sr_ && [CollidingRectsCreator validPos:CGPointMake(self.center.x + x, self.center.y + y)]) {
                [self.spreadPoints addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
                i--;
            }
        }
        
        self.megaTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(dealDamageToMe) userInfo:nil repeats:YES];
//        self.alpha = 0.1f;
        
    }
    return self;
}

- (BOOL)moves {
    return NO;
}

- (void)die {
    for (HeartGuardBot *bot in self.trackingBots) {
        if (bot.enemyKey == self) bot.enemyKey = nil;
    }
    [self.trackingBots removeAllObjects];
}

- (void)dealDamageToMe {
    for (HeartGuardBot *hgb in self.trackingBots) {
        //THIS IS WHERE BOTS DAMAGE THE PLAQUE
    }
}

- (void)destinationReached:(id)sender {
//    HeartGuardBot *bot = (HeartGuardBot *)sender;
//    self.hp--;
//    [self stainAtPoint:[self convertPoint:bot.frame.origin fromView:[self superview]]];
//    [self.livingGuyManager livingGuy:self killsLivingGuy:bot];
//    if (self.hp <= 0) {
//        [self.livingGuyManager livingGuyDies:self];
//    }
}

- (void)track:(HeartGuardBot *)bot {
    [self.trackingBots addObject:bot];
    bot.enemyKey = self;
}

- (CGPoint)findASpreadPoint {
//    CGPoint p = self.center;
//    CGRect r = self.frame;
//    return self.center;
//    return CGPointMake(self.center.x + self.plaqueView.center.x, self.center.y + self.plaqueView.center.y);
    CGPoint p = [[self.spreadPoints objectAtIndex:arc4random()%self.numSpreadPoints] CGPointValue];
    return CGPointMake(self.center.x + p.x, self.center.y + p.y);
}

- (void)setHp:(int)hp {
    [super setHp:hp];
    [self updateAlpha];
}

- (void)updateAlpha {
    self.alpha = self.hp / self.maxhp;
}

@end
