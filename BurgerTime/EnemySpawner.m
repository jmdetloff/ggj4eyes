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
#import "ParasiteEnemy.h"

@implementation EnemySpawner

+ (ParentEnemy *)createEnemyForWave:(Wave*)w {
    if ([w.enemy_type isEqualToString:@"Tear"]) {
        return [[HeartLeakEnemy alloc] initWithHP:w.hp];
    } else if ([w.enemy_type isEqualToString:@"Plaque"]) {
        return [[PlaqueEnemy alloc] initWithHP:w.hp spreadRadius:30];
    } else if ([w.enemy_type isEqualToString:@"Parasite"]) {
        return [[ParasiteEnemy alloc] init];
    } else {
        return nil;
    }
}

@end
