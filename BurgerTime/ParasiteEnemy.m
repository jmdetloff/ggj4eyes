//
//  ParasiteEnemy.m
//  BurgerTime
//
//  Created by John Detloff on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "ParasiteEnemy.h"
#import "HeartGuardBot.h"

@implementation ParasiteEnemy {
    BOOL _canHaveVictim;
}

- (id)init {
    self = [super init];
    if (self) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        NSArray *images = @[[UIImage imageNamed:@"toxin_01.png"],[UIImage imageNamed:@"toxin_02.png"],[UIImage imageNamed:@"toxin_03.png"]];
        image.animationImages = images;
        image.animationDuration = 0.5;
        image.animationRepeatCount = 0;
        [self addSubview:image];
        [image startAnimating];
        self.frame = CGRectMake(0, 0, image.frame.size.width, image.frame.size.height);
        _canHaveVictim = YES;
        self.hp = 5;
    }
    return self;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.position = CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height/2);
}


- (EnemyType)botType {
    return PARASITE;
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


- (void)advance:(double)dt {
    [super advance:dt];
    if (self.victim) {
        [self setDestinationPoint:self.victim.center];
    }
}

- (void)collided:(double)dt {
    [super collided:dt];
    self.victim = nil;
    _canHaveVictim = NO;
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _canHaveVictim = YES;
    });
}


- (void)setVictim:(HeartGuardBot *)victim {
    if (_canHaveVictim) {
        _victim = victim;
    }
    
    if (victim == nil) {
        [self clearDestination];
    }
}


- (void)clearDestination {
    [super clearDestination];
    _victim =  nil;
}


- (void)zap:(HeartGuardBot *)attacker {
    self.hp--;
    if (self.hp <= 0) {
        [self.livingGuyManager livingGuy:attacker killsLivingGuy:self];
    }
}

@end
