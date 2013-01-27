//
//  EnemySpawner.m
//  BurgerTime
//
//  Created by John Detloff on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "EnemySpawner.h"
#import "HeartLeakEnemy.h"

@implementation EnemySpawner

+ (ParentEnemy *)createEnemyForType:(EnemyType)enemyType {
    switch (enemyType) {
        case TEAR :
            return [[HeartLeakEnemy alloc] initWithHP:30];
            break;
            
        default:
            return nil;
            break;
    }
}

@end
