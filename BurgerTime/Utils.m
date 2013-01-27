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
    return ((arc4random()%ULONG_MAX)/ULONG_MAX) * (b-a) + a;
}

@end
