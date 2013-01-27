//
//  LivingGuyManager.m
//  BurgerTime
//
//  Created by John Detloff on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "LivingGuyManager.h"

@implementation LivingGuyManager

- (id)init {
    self = [super init];
    if (self) {
        _bots = [[NSMutableArray alloc] init];
        _enemies = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)livingGuy:(UIView <LivingGuy> *)killer killsLivingGuy:(UIView <LivingGuy> *)victim {
    if ([_enemies containsObject:victim]) {
        [_enemies removeObject:victim];
    }
    if ([_bots containsObject:victim]) {
        [_bots removeObject:victim];
    }
    [victim die];
    [self.deathDelegate viewDied:victim];
}

- (void)livingGuyDies:(UIView <LivingGuy> *)victim {
    if ([_enemies containsObject:victim]) {
        [_enemies removeObject:victim];
    }
    if ([_bots containsObject:victim]) {
        [_bots removeObject:victim];
    }
    [victim die];
    [self.deathDelegate viewDied:victim];
}


- (void)livingGuyReproduces:(UIView <LivingGuy> *)mom {
    [self.deathDelegate viewWasBornAtPoint:mom.center];
}


- (void)livingGuy:(UIView <LivingGuy> *)guy dealsHeartDamage:(int)damage {
    [self.deathDelegate dealHeartDamage:damage];
}


@end
