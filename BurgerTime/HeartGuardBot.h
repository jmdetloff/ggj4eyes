//
//  HeartGuardBot.h
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeartGuardBot : UIView
{
    
}
-(UIColor *)botColor;
//typedef  types;
@property  enum    { SCRUB, PLUG, FIGHT, HEALER, SPAWNBOT }  botType;

@property int level;
@property int range;



@end
