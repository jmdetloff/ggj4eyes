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
        botType = arc4random() % 5;
        // Probably not what we want to do.
        
        self.opaque = YES;
    }
    return self;
}

-(UIColor *)botColor  // color blind people are screwed
{
    switch(botType) {
        case SCRUB:
            return [UIColor blackColor];
        case PLUG:
            return [UIColor blueColor];
        case FIGHT:
            return [UIColor redColor];
        case HEALER:
            return [UIColor greenColor];
        case SPAWNBOT:
            return [UIColor yellowColor];
    }
    NSLog(@"Made it through color switch without picking a color");
    return [UIColor blackColor]; // removes warning
}


@end
