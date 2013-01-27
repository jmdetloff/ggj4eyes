//
//  EnemyBot.h
//  BurgerTime
//
//  Created by stanza on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovingCollidingGuy.h"
#import "LivingGuyManager.h"

typedef enum { TEAR, PLAQUE, PARASITE, ATHEROSCLEROSIS, ISCHAEMIA, CARDIOMYOPATHY } EnemyType;

@interface ParentEnemy : MovingCollidingGuy <DestinationDelegate, LivingGuy>
@property  (nonatomic, assign) EnemyType botType;
@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int atk;
@property (nonatomic, assign) int splash_radius;

-(NSString *)name;
-(UIColor *)color;
- (void)die;

@end
