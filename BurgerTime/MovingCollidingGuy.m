//
//  MovingCollidingGuy.m
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "MovingCollidingGuy.h"
#import "CollidingRectsCreator.h"
#import "Utils.h"

#define N_DIRECTIONS 8

@implementation MovingCollidingGuy {
    MovementDirection _previousMovementDirection;
    CGPoint _destinationPoint;
    BOOL _destinationValid;
}

@synthesize angle, velocity, position, cycleState, cyclePivot, cycleRadius, cycleParticleStart;

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
        self.cycleState = 0;
    }
    return self;
}

- (float)cycleAngularVelocity {
    if (cycleState != 2)
        return 0;
    return self.velocity / self.cycleRadius;
}

- (void)orderCycleWithPivot:(CGPoint)pivot_ radius:(float)radius_ {
    if (self.cycleState != 0)
        return;
    
    self.cycleState = 1;
    self.cyclePivot = pivot_;
    self.cycleRadius = radius_;
    
    float currentDist = [Utils distanceBetween:self.position and:pivot_];
    float dx = self.position.y - pivot_.y;
    float dy = self.position.x - pivot_.x;
    float scale = radius_ / currentDist;
    
    self.cycleParticleStart = CGPointMake(pivot_.x + dx * scale, pivot_.y + dy * scale);
    
    [self setDestinationPoint:self.cycleParticleStart];
}

- (void)advance:(double)dt {
    if (_destinationValid) {
        float dy = _destinationPoint.y - self.position.y;
        float dx = _destinationPoint.x - self.position.x;
        if (sqrtf(dx*dx + dy*dy) < 4)
            [self reachedDestination];
        self.angle = atan2(_destinationPoint.y - self.position.y, _destinationPoint.x - self.position.x);
    }
    if (![CollidingRectsCreator validPos:[self nextPos:dt withAngle:self.angle]]) {
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
        if ([CollidingRectsCreator validPos:[self nextPos:multiplier * dt withAngle:ang]])
            break;
        tries++;
        if (tries > 15)
            multiplier++;
    }
    self.angle = ang;
}

- (void)setDestinationPoint:(CGPoint)destinationPoint {
    [self clearDestination];
    
    _destinationPoint = destinationPoint;
    _destinationValid = YES;
}

- (void)clearDestination {
    self.enemyKey = nil;
    _destinationValid = NO;
    [self rerollAngle:0];
}

- (void)stopCycling {
    self.cycleState = 0;
    [self clearDestination];
}

- (float)currentCycleAngle {
    if (self.cycleState != 2)
        return 0;
    return atan2f(self.position.y - self.cyclePivot.y, self.position.x - self.cyclePivot.x);
}

- (CGPoint)nextCycleDestination {
    float ang = [self currentCycleAngle];
    ang += [self cycleAngularVelocity];
    if (ang > M_PI)
        ang -= 2 * M_PI;
    float dx = self.cycleRadius * cosf(ang);
    float dy = self.cycleRadius * sinf(ang);
    return CGPointMake(self.cyclePivot.x + dx, self.cyclePivot.y + dy);
}

- (void)reachedDestination {
    if (self.cycleState == 1) {
        self.cycleState = 2;
    }
    if (self.cycleState == 2) {
        [self setDestinationPoint:[self nextCycleDestination]];
        return;
    }
    if (self.enemyKey) {
        [self.enemyKey destinationReached:self];
    }
    [self clearDestination];
}
            
@end
