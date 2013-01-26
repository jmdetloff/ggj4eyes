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
@property int botType;
// Should make an enum
// in the meantime:
// 0 - scrub
// 1 - plug
// 2 - fight
// 3 - healer
// 4 - mombot/spawnbot

@property int level;
@property int range;



@end
