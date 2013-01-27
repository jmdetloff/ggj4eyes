//
//  EnemySpawner.h
//  BurgerTime
//
//  Created by John Detloff on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentEnemy.h"
#import "Wave.h"

@interface EnemySpawner : NSObject
+ (ParentEnemy *)createEnemyForWave:(Wave*)w;
@end
