//
//  EnemyBot.h
//  BurgerTime
//
//  Created by stanza on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnemyBot : UIView
typedef enum { ENDOCARDITIS, MYOCARDITIS, ATHEROSCLEROSIS, ISCHAEMIA, CARDIOMYOPATHY } types;
@property types botType;
@property int hp;
@property int atk;
@property int splash_radius;

-(NSString *)name;
-(UIColor *)color;


@end
