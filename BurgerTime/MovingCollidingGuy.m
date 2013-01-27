//
//  MovingCollidingGuy.m
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "MovingCollidingGuy.h"
#import "CollidingRectsCreator.h"

#define N_DIRECTIONS 8

@implementation MovingCollidingGuy {
    MovementDirection _previousMovementDirection;
    CGPoint _destinationPoint;
    BOOL _destinationValid;
}


@synthesize angle, velocity, position;

- (float)ithAngle:(int)i {
    //i should be in [0, N_DIRECTIONS-1]
    return -M_PI + 2 * M_PI * i / N_DIRECTIONS;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.position = frame.origin;
        self.angle = 0;
        self.velocity = 30;
    }
    return self;
}

- (void)advance:(double)dt {
    if (_destinationValid) {
        float dy = _destinationPoint.y - self.position.y;
        float dx = _destinationPoint.x - self.position.x;
        if (sqrtf(dx*dx + dy*dy) < 4)
            [self reachedDestination];
        self.angle = atan2(_destinationPoint.y - self.position.y, _destinationPoint.x - self.position.x);
    }
    if (![MovingCollidingGuy validPos:[self nextPos:dt withAngle:self.angle]]) {
        [self clearDestination];
        [self rerollAngle:dt];
    }
    self.position = [self nextPos:dt withAngle:self.angle];
    
    self.frame = CGRectMake(self.position.x - self.frame.size.width/2, self.position.y - self.frame.size.height/2, self.frame.size.width, self.frame.size.height);
}

- (CGPoint)nextPos:(double)dt withAngle:(float)ang {
    float dx = self.velocity*dt*cosf(ang);
    float dy = self.velocity*dt*sinf(ang);
    return CGPointMake(self.position.x + dx, self.position.y + dy);
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

- (void)rerollAngle:(double)dt {
    if (_destinationValid)
        return;
    int index;
    float ang;
    
    int tries = 0;
    float multiplier = 1;
    
    while (1) {
        index = arc4random()%N_DIRECTIONS;
        ang = [self ithAngle:index];
        if (dt == 0)
            break;
        if ([MovingCollidingGuy validPos:[self nextPos:multiplier * dt withAngle:ang]])
            break;
        tries++;
        if (tries > 15)
            multiplier++;
    }
    self.angle = ang;
}

- (void)setDestinationPoint:(CGPoint)destinationPoint withDuration:(NSTimeInterval)duration {
    [self clearDestination];
    
    _destinationPoint = destinationPoint;
    _destinationValid = YES;
}

- (void)clearDestination {
    self.enemyKey = nil;
    _destinationValid = NO;
    [self rerollAngle:0];
}

- (void)reachedDestination {
    if (self.enemyKey) {
        [self.enemyKey destinationReached:self];
    }
    [self clearDestination];
}

- (CGFloat) distanceBetween:(CGPoint)point1 and:(CGPoint)point2 {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrtf(dx*dx + dy*dy);
}
            
@end
