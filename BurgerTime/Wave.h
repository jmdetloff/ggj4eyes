//
//  Wave.h
//  BurgerTime
//
//  Created by stanza on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnemyBot.h"

@interface Wave : NSObject
/*
id	hp	atk	num_enemies	enemy_type
int	int	int	int	str
1	1	1	3	endo
 */
@property int level_id;
@property int hp;
@property int num_enemies;
@property EnemyType type;
@end
