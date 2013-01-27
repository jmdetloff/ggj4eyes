//
//  CollidingRectsCreator.m
//  BurgerTime
//
//  Created by John Detloff on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "CollidingRectsCreator.h"

@implementation CollidingRectsCreator

+(NSArray *)scaleArray:(NSArray *)array withScale:(CGFloat)scale
{
    NSMutableArray *workingArray = [[NSMutableArray alloc] init];
    for (NSValue *v in array) {
        CGRect r = [v CGRectValue];
        CGRect rect = CGRectMake(r.origin.x * scale, r.origin.y * scale, r.size.width * scale, r.size.height * scale);
        [workingArray addObject:[NSValue valueWithCGRect:rect]];
    }
    return [NSArray arrayWithArray:workingArray];
}

+(NSArray *)collidingRectsForHeartWithScale:(CGFloat)scale {
    static NSArray *scaledArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scaledArray = [self scaleArray:[self collidingRectsForHeartForIpad] withScale:scale];
    });
    return scaledArray;
}

+(NSArray *)validSpawningLocationsWithScale:(CGFloat)scale {
    static NSArray *scaledSpawnArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scaledSpawnArray = [self scaleArray:[self validSpawningLocationsForIpad] withScale:scale];
    });
    return scaledSpawnArray;
}

+(NSArray *)collidingRectsForHeartForIpad
{
    NSArray *rects = @[[NSValue valueWithCGRect:CGRectMake(216,580,11,36)],
        [NSValue valueWithCGRect:CGRectMake(203.5,595.5,13.5,15)],
        [NSValue valueWithCGRect:CGRectMake(186,609,18.5,13)],
        [NSValue valueWithCGRect:CGRectMake(92,630,95,28)],
        [NSValue valueWithCGRect:CGRectMake(77.5,596,28.6,31.5)],
        [NSValue valueWithCGRect:CGRectMake(51.5,415,36.5,205.5)],
        [NSValue valueWithCGRect:CGRectMake(75,380,28,47.5)],
        [NSValue valueWithCGRect:CGRectMake(69.5,325,50.5,68.5)],
        [NSValue valueWithCGRect:CGRectMake(106,180,29,144.5)],
        [NSValue valueWithCGRect:CGRectMake(77.5,57,43,142.5)],
        [NSValue valueWithCGRect:CGRectMake(117,33,93,42)],
        [NSValue valueWithCGRect:CGRectMake(206,66,45,299)],
        [NSValue valueWithCGRect:CGRectMake(197,178,42,125)],
        [NSValue valueWithCGRect:CGRectMake(232.5,355,49.5,55)],
        [NSValue valueWithCGRect:CGRectMake(264,323,45,50.5)],
        [NSValue valueWithCGRect:CGRectMake(289.5,202,47,139)],
        [NSValue valueWithCGRect:CGRectMake(307,285,47,52)],
        [NSValue valueWithCGRect:CGRectMake(323,165,53,43)],
        [NSValue valueWithCGRect:CGRectMake(345,152,195,41)],
        [NSValue valueWithCGRect:CGRectMake(510,187,90,125.5)],
        [NSValue valueWithCGRect:CGRectMake(487,259,28,100)],
        [NSValue valueWithCGRect:CGRectMake(470,295,20.5,127)],
        [NSValue valueWithCGRect:CGRectMake(458,336,15.5,260)],
        [NSValue valueWithCGRect:CGRectMake(442,450,19.5,100)],
        [NSValue valueWithCGRect:CGRectMake(596.5,256,40,88.5)],
        [NSValue valueWithCGRect:CGRectMake(626,279,39.5,155.5)],
        [NSValue valueWithCGRect:CGRectMake(651,380,46,105)],
        [NSValue valueWithCGRect:CGRectMake(671,467,44,49)],
        [NSValue valueWithCGRect:CGRectMake(692,504,76,297)],
        [NSValue valueWithCGRect:CGRectMake(669,774,64,52.5)],
        [NSValue valueWithCGRect:CGRectMake(638.5,811,62,48)],
        [NSValue valueWithCGRect:CGRectMake(478,833,230,48)],
        [NSValue valueWithCGRect:CGRectMake(512.5,779,17.5,73)],
        [NSValue valueWithCGRect:CGRectMake(314,873,192,42.5)],
        [NSValue valueWithCGRect:CGRectMake(268,855,59,39)],
        [NSValue valueWithCGRect:CGRectMake(250.5,826,43,41)],
        [NSValue valueWithCGRect:CGRectMake(227,750,33.5,59.5)],
        [NSValue valueWithCGRect:CGRectMake(198,777,35,82.5)],
        [NSValue valueWithCGRect:CGRectMake(166.5,752,35.5,83.5)],
        [NSValue valueWithCGRect:CGRectMake(139.5,642,32,113)]];
    
    return rects;
}
+(NSArray *)validSpawningLocationsForIpad
{
    return  @[[NSValue valueWithCGRect:CGRectMake(125,369,90,237)],
    [NSValue valueWithCGRect:CGRectMake(250,380,200,400)],
    [NSValue valueWithCGRect:CGRectMake(516,330,89,399)]];
}

+ (BOOL)validPos:(CGPoint)pos {
    for (NSValue *v in [CollidingRectsCreator collidingRectsForHeartWithScale:1]) {
        CGRect r = [v CGRectValue];
        if (pos.x >= r.origin.x &&
            pos.y >= r.origin.y &&
            pos.x <= r.origin.x + r.size.width &&
            pos.y <= r.origin.y + r.size.height) {
            return NO;
        }
    }
    return YES;
}

@end
