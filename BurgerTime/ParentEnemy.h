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

@class HeartGuardBot;

typedef enum { TEAR, PLAQUE, PARASITE } EnemyType;

@interface ParentEnemy : MovingCollidingGuy <DestinationDelegate, LivingGuy>
@property (nonatomic, assign) EnemyType botType;
@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int maxhp;
@property (nonatomic, assign) int bot_atk;
@property (nonatomic, assign) int heart_atk;
@property (nonatomic, assign) int splash_radius;
@property (nonatomic, assign) int kill_reward;
@property (nonatomic, strong) NSMutableArray *trackingBots;

-(NSString *)name;
-(UIColor *)color;
- (void)die;
+(NSString*)nameFromType:(EnemyType)type;
- (void)attack;
- (void)untrack:(HeartGuardBot *)bot;
@end
