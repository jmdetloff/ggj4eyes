//
//  Utils.m
//  BurgerTime
//
//  Created by Michel D'Sa on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (float)randomFloatBetween:(float)a And:(float)b {
    return (((double)(arc4random()%ULONG_MAX))/ULONG_MAX) * (b-a) + a;
}

+ (CGFloat) distanceBetween:(CGPoint)point1 and:(CGPoint)point2 {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrtf(dx*dx + dy*dy);
}



@end