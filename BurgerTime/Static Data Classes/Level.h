//
//  Level.h
//  BurgerTime
//
//  Created by Michel D'Sa on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject

@property (nonatomic) int pk;
@property (nonatomic) int starting_points;
@property (nonatomic) int starting_bot_num;
@property (nonatomic, strong) NSArray *wave_ids;
@property (nonatomic, strong) NSArray *wave_times;

@end
