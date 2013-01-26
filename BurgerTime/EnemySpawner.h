//
//  EnemySpawner.h
//  BurgerTime
//
//  Created by John Detloff on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnemyBot.h"

@interface EnemySpawner : NSObject
+ (EnemyBot *)createEnemyForType:(EnemyType)enemyType;
@end
