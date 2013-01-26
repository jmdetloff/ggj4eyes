//
//  CollidingRectsCreator.h
//  BurgerTime
//
//  Created by John Detloff on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollidingRectsCreator : NSObject


+ (NSArray *)collidingRectsForHeartWithScale:(CGFloat)scale;
+ (NSArray *)validSpawningLocationsWithScale:(CGFloat)scale;

@end
