//
//  HeartGuardBot.m
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "HeartGuardBot.h"
#import <QuartzCore/QuartzCore.h>

static NSArray *_botColors;

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

-(void)setBotImage {
    if (!_botColors)
        _botColors = [NSArray arrayWithObjects:@"white", @"blue", @"red", @"green", @"yellow", nil];
    UIImage *botImage = [UIImage imageNamed:[NSString stringWithFormat:@"nanobot_%@.png", [_botColors objectAtIndex:self.botType]]];
    [self addSubview:[[UIImageView alloc] initWithImage:botImage]];
}


@end
