//
//  PlaqueEnemy.h
//  BurgerTime
//
//  Created by Michel D'Sa on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "EnemyBot.h"

@interface PlaqueEnemy : EnemyBot

//@property (nonatomic) CGPoint position;
@property (nonatomic, strong) UIImageView *plaqueView;
@property (nonatomic, strong) NSMutableArray *spreadPoints;
@property (nonatomic) int numSpreadPoints;

- (id)initWithHP:(int)hp_ spreadRadius:(float)sr_;
- (CGPoint)findASpreadPoint;

@end
