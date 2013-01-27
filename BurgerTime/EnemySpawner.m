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

+ (EnemyBot *)createEnemyForType:(EnemyType)enemyType {
    switch (enemyType) {
        case TEAR :
            return [[HeartLeakEnemy alloc] initWithHP:30];
            break;
        case PLAQUE :
            return [[PlaqueEnemy alloc] initWithPosition:CGPointMake(100, 100) hp:20 spreadRadius:1];
            break;
        default:
            return nil;
            break;
    }
}

@end
