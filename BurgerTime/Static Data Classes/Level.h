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
@property (nonatomic, strong) NSString *wave_ids;
@property (nonatomic, strong) NSString *wave_times;

@end
