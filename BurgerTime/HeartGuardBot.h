//
//  HeartGuardBot.h
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "MovingCollidingGuy.h"
#import <UIKit/UIKit.h>

@interface HeartGuardBot : MovingCollidingGuy
{
    
}
-(UIColor *)botColor;
typedef   enum    { SCRUB, PLUG, FIGHT, HEALER, SPAWNBOT } types;
@property types  botType;

@property int level;
@property int range;

@end