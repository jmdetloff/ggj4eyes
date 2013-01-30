//
//  PlaqueEnemy.h
//  BurgerTime
//
//  Created by Michel D'Sa on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "ParentEnemy.h"
#import "HeartGuardBot.h"

//#define PLAQUE_HP_MULTIPLIER 50

@interface PlaqueEnemy : ParentEnemy

//@property (nonatomic) CGPoint position;
@property (nonatomic, strong) UIImageView *plaqueView;
@property (nonatomic, strong) NSMutableArray *spreadPoints;
@property (nonatomic) int numSpreadPoints;
@property (nonatomic, strong) NSTimer *megaTimer;

- (id)initWithHP:(int)hp_ spreadRadius:(float)sr_;
- (CGPoint)findASpreadPoint;
- (void)track:(HeartGuardBot *)bot;

@end
