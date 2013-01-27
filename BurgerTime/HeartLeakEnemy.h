//
//  HeartLeakEnemy.h
//  BurgerTime
//
//  Created by John Detloff on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "ParentEnemy.h"

@class HeartGuardBot;
@interface HeartLeakEnemy : ParentEnemy

@property (nonatomic, strong) NSMutableArray *trackingBots;

- (id)initWithHP:(NSInteger)hp;
- (void)track:(HeartGuardBot *)bot;

@end
