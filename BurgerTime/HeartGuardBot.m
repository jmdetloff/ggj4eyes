//
//  HeartGuardBot.m
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "HeartGuardBot.h"
#import <QuartzCore/QuartzCore.h>

@implementation HeartGuardBot
@synthesize botType;
@synthesize level;
@synthesize range;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        botType = arc4random() % 5; // Probably not what we want to do.
    }
    return self;
}

-(UIColor *)botColor  // color blind people are screwed
{
    switch(botType) {
        case 0:
            return [UIColor blackColor];
        case 1:
            return [UIColor blueColor];
        case 2:
            return [UIColor redColor];
        case 3:
            return [UIColor greenColor];
        case 4:
            return [UIColor yellowColor];
    }
    NSLog(@"Made it through color switch without picking a color");
    return [UIColor blackColor]; // removes warning
}


@end
