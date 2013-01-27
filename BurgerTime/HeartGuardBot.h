//
//  HeartGuardBot.h
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "MovingCollidingGuy.h"
#import "EnemyBot.h"
#import "LivingGuyManager.h"
#import <UIKit/UIKit.h>

@interface HeartGuardBot : MovingCollidingGuy <LivingGuy>

typedef   enum    { STANDARD, SCRUB, HEALER, SPAWNBOT, FIGHT } NanabotType;

@property int level;
@property int range;
@property (nonatomic, assign) NanabotType nanobotType;

- (void)interactWithEnemy:(EnemyBot *)enemy;
- (void)setBotImage;

@end
