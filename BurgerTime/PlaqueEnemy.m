//
//  PlaqueEnemy.m
//  BurgerTime
//
//  Created by Michel D'Sa on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "PlaqueEnemy.h"

@implementation PlaqueEnemy

@synthesize position;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithPosition:(CGPoint)position_ hp:(int)hp_ spreadRadius:(float)sr_ {
    self = [super init];
    if (self) {
        self.position = position_;
        self.maxhp = hp_;
        self.hp = hp_;
    }
    return self;
}

- (void)updateAlpha {
    self.alpha = self.hp / self.maxhp;
}

@end
