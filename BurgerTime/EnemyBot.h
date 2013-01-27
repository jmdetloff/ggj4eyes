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

typedef enum { TEAR, PLAQUE, MYOCARDITIS, ATHEROSCLEROSIS, ISCHAEMIA, CARDIOMYOPATHY } EnemyType;

@interface EnemyBot : MovingCollidingGuy <DestinationDelegate, LivingGuy>
@property (nonatomic, assign) EnemyType botType;
@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int maxhp;
@property (nonatomic, assign) int atk;
@property (nonatomic, assign) int splash_radius;

-(NSString *)name;
-(UIColor *)color;
- (void)die;

@end
