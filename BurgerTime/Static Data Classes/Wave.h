//
//  Wave.h
//  BurgerTime
//
//  Created by Michel D'Sa on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wave : NSObject

@property (nonatomic) int pk;
@property (nonatomic) int hp;
@property (nonatomic) int bot_atk;
@property (nonatomic) int heart_atk;
@property (nonatomic, strong) NSString *enemy_type;

@end
