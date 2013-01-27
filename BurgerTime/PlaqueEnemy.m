//
//  PlaqueEnemy.m
//  BurgerTime
//
//  Created by Michel D'Sa on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "PlaqueEnemy.h"
#import "Utils.h"

static const float _sideLength = 40;

@implementation PlaqueEnemy

@synthesize position, plaqueView, spreadPoints, numSpreadPoints;

- (id)initWithPosition:(CGPoint)position_ hp:(int)hp_ spreadRadius:(float)sr_ {
    self = [super init];
    if (self) {
        self.position = position_;
        self.maxhp = hp_;
        self.hp = hp_;
        self.botType = PLAQUE;
        
        //randomly pick a plaque image
        NSString *plaqueImageName = [NSString stringWithFormat:@"_plaqu%02d.png", arc4random()%3 + 1];
        self.plaqueView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:plaqueImageName]];
        self.plaqueView.frame = CGRectMake(-_sideLength/2,
                                           -_sideLength/2,
                                           _sideLength,
                                           _sideLength);
        
        self.numSpreadPoints = 4;
        
        //randomly pick 4 "scrub points" within the spread radius
        int i = self.numSpreadPoints;
        self.spreadPoints = [NSMutableArray array];
        while (i > 0) {
            float x = [Utils randomFloatBetween:-sr_/2 And:sr_/2];
            float y = [Utils randomFloatBetween:-sr_/2 And:sr_/2];
            if (x*x + y*y <= sr_*sr_) {
                [self.spreadPoints addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
                i--;
            }
        }
        
        
        [self addSubview:self.plaqueView];
    }
    return self;
}

- (CGPoint)findASpreadPoint {
    return [[self.spreadPoints objectAtIndex:arc4random()%self.numSpreadPoints] CGPointValue];
}

- (void)updateAlpha {
    self.alpha = self.hp / self.maxhp;
}

@end
