//
//  EnemySpawner.m
//  BurgerTime
//
//  Created by John Detloff on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "EnemySpawner.h"
#import "HeartLeakEnemy.h"
#import "PlaqueEnemy.h"

@implementation EnemySpawner

+ (ParentEnemy *)createEnemyForType:(EnemyType)enemyType {
    switch (enemyType) {
        case TEAR :
            return [[HeartLeakEnemy alloc] initWithHP:30];
            break;
        case PLAQUE :
            return [[PlaqueEnemy alloc] initWithHP:20 spreadRadius:20];
            break;
        default:
            return nil;
            break;
    }
}

@end
