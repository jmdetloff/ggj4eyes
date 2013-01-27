//
//  ParasiteEnemy.h
//  BurgerTime
//
//  Created by John Detloff on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "ParentEnemy.h"
@class HeartGuardBot;
@interface ParasiteEnemy : ParentEnemy

@property (nonatomic, strong) HeartGuardBot *victim;

- (void)zap:(HeartGuardBot *)attacker;

@end
