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
#import "ParentEnemy.h"

@implementation EnemySpawner

+ (ParentEnemy *)createEnemyForWave:(Wave*)w {
    ParentEnemy *pe;
    int hpmult = 1;
    if ([w.enemy_type isEqualToString:@"Tear"]) {
        pe = [[HeartLeakEnemy alloc] initWithHP:w.hp];
    } else if ([w.enemy_type isEqualToString:@"Plaque"]) {
        pe = [[PlaqueEnemy alloc] initWithHP:w.hp spreadRadius:30];
        hpmult = PLAQUE_HP_MULTIPLIER;
    } else if ([w.enemy_type isEqualToString:@"Parasite"]) {
        pe = [[ParasiteEnemy alloc] init];
    } else {
        return nil;
    }
    pe.hp = w.hp * hpmult;
    pe.maxhp = pe.hp;
    pe.bot_atk = w.bot_atk;
    pe.heart_atk = w.heart_atk;
    pe.kill_reward = w.reward;
    return pe;
}

@end
