//
//  CollidingRectsCreator.m
//  BurgerTime
//
//  Created by John Detloff on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "CollidingRectsCreator.h"

@implementation CollidingRectsCreator


+ (NSArray *)collidingRectsForHeartWithScale:(CGFloat)scale {
    NSArray *rects = @[[NSValue valueWithCGRect:CGRectMake(216,610.5,11,36)],
                    [NSValue valueWithCGRect:CGRectMake(203.5,645.5,13.5,15)],
                    [NSValue valueWithCGRect:CGRectMake(186,659,18.5,13)],
                    [NSValue valueWithCGRect:CGRectMake(92,670,95,28)],
                    [NSValue valueWithCGRect:CGRectMake(77.5,646.5,28.6,31.5)],
                    [NSValue valueWithCGRect:CGRectMake(51.5,464.5,36.5,205.5)],
                    [NSValue valueWithCGRect:CGRectMake(75,432.5,28,47.5)],
                    [NSValue valueWithCGRect:CGRectMake(69.5,373.5,50.5,68.5)],
                    [NSValue valueWithCGRect:CGRectMake(106,235.5,29,144.5)],
                    [NSValue valueWithCGRect:CGRectMake(77.5,116.5,43,142.5)],
                    [NSValue valueWithCGRect:CGRectMake(117,83,93,42)],
                    [NSValue valueWithCGRect:CGRectMake(206,116,45,299)],
                    [NSValue valueWithCGRect:CGRectMake(197,228.5,42,125)],
                    [NSValue valueWithCGRect:CGRectMake(232.5,405,49.5,55)],
                    [NSValue valueWithCGRect:CGRectMake(264,373.5,45,50.5)],
                    [NSValue valueWithCGRect:CGRectMake(289.5,252,47,139)],
                    [NSValue valueWithCGRect:CGRectMake(307,235.5,47,52)],
                    [NSValue valueWithCGRect:CGRectMake(323,215.5,53,43)],
                    [NSValue valueWithCGRect:CGRectMake(345,202,195,41)],
                    [NSValue valueWithCGRect:CGRectMake(510,237,90,125.5)],
                    [NSValue valueWithCGRect:CGRectMake(487,309,28,100)],
                    [NSValue valueWithCGRect:CGRectMake(470,345,20.5,127)],
                    [NSValue valueWithCGRect:CGRectMake(458,386.5,15.5,260)],
                    [NSValue valueWithCGRect:CGRectMake(442,500,19.5,100)],
                    [NSValue valueWithCGRect:CGRectMake(596.5,306,40,88.5)],
                    [NSValue valueWithCGRect:CGRectMake(626,329,39.5,155.5)],
                    [NSValue valueWithCGRect:CGRectMake(651,430,46,105)],
                    [NSValue valueWithCGRect:CGRectMake(671,517,44,49)],
                    [NSValue valueWithCGRect:CGRectMake(692,554,76,297)],
                    [NSValue valueWithCGRect:CGRectMake(669,824,64,52.5)],
                    [NSValue valueWithCGRect:CGRectMake(638.5,861,62,48)],
                    [NSValue valueWithCGRect:CGRectMake(478,883,230,48)],
                    [NSValue valueWithCGRect:CGRectMake(512.5,829,17.5,73)],
                    [NSValue valueWithCGRect:CGRectMake(314,923,192,42.5)],
                    [NSValue valueWithCGRect:CGRectMake(268,905,59,39)],
                    [NSValue valueWithCGRect:CGRectMake(250.5,876.5,43,41)],
                    [NSValue valueWithCGRect:CGRectMake(227,847.5,33.5,59.5)],
                    [NSValue valueWithCGRect:CGRectMake(198,827,35,82.5)],
                    [NSValue valueWithCGRect:CGRectMake(166.5,802,35.5,83.5)],
                    [NSValue valueWithCGRect:CGRectMake(139.5,692.5,32,113)]];
    return rects;
}


+ (NSArray *)validSpawningLocationsWithScale:(CGFloat)scale {
    return nil;
}


@end
