//
//  HeartLeakEnemy.h
//  BurgerTime
//
//  Created by John Detloff on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "EnemyBot.h"

@class HeartGuardBot;
@interface HeartLeakEnemy : EnemyBot

@property (nonatomic, strong) NSMutableArray *trackingBots;

- (id)initWithHP:(NSInteger)hp;
- (void)track:(HeartGuardBot *)bot;

@end
