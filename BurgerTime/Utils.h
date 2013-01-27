//
//  Utils.h
//  BurgerTime
//
//  Created by Michel D'Sa on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (float)randomFloatBetween:(float)a And:(float)b;
+ (CGFloat) distanceBetween:(CGPoint)point1 and:(CGPoint)point2;
+ (UIImage *)portraitImageForLevel:(int)level;
@end
