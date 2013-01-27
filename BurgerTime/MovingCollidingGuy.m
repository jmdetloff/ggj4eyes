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
//#define N_BOUNDING_RECTS 1
//
//static float _boundRects[] = {
//    -10, -10, 20, 788
//};

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
//    
//    
//    
//    for (int i = 0;i < N_BOUNDING_RECTS;i++) {
//        if (pos.x >= _boundRects[4*i + 0] &&
//            pos.y >= _boundRects[4*i + 1] &&
//            pos.x <= _boundRects[4*i + 0] + _boundRects[4*i + 2] &&
//            pos.y <= _boundRects[4*i + 1] + _boundRects[4*i + 3])
//            return NO;
//    }
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


- (NSArray *)blockedDirectionsForBlockingRectangles:(NSArray *)blockingRectangles {
    NSMutableArray *blockedDirections = [[NSMutableArray alloc] init];
    for (NSValue *rectVal in blockingRectangles) {
        CGRect blockingRect = [rectVal CGRectValue];
        CGRect selfFrame = self.frame;
        
        CGFloat naiveDistance = [self distanceBetween:self.center and:blockingRect.origin];
        if (naiveDistance > blockingRect.size.width + selfFrame.size.width && naiveDistance > blockingRect.size.height + selfFrame.size.height) {
            continue;
        }
        
        CGPoint topLeft = selfFrame.origin;
        CGPoint topRight = CGPointMake(CGRectGetMaxX(selfFrame), selfFrame.origin.y);
        CGPoint bottomLeft = CGPointMake(selfFrame.origin.x, CGRectGetMaxY(selfFrame));
        CGPoint bottomRight = CGPointMake(CGRectGetMaxX(selfFrame), CGRectGetMaxY(selfFrame));
        
        if (CGRectContainsPoint(blockingRect, topLeft)) {
            if (![blockedDirections containsObject:[NSNumber numberWithInt:Left]]) [blockedDirections addObject:[NSNumber numberWithInt:Left]];
            if (![blockedDirections containsObject:[NSNumber numberWithInt:Up]])[blockedDirections addObject:[NSNumber numberWithInt:Up]];
        }
        
        if (CGRectContainsPoint(blockingRect, topRight)) {
            if (![blockedDirections containsObject:[NSNumber numberWithInt:Right]])[blockedDirections addObject:[NSNumber numberWithInt:Right]];
            if (![blockedDirections containsObject:[NSNumber numberWithInt:Up]])[blockedDirections addObject:[NSNumber numberWithInt:Up]];
        }

        if (CGRectContainsPoint(blockingRect, bottomLeft)) {
            if (![blockedDirections containsObject:[NSNumber numberWithInt:Down]]) [blockedDirections addObject:[NSNumber numberWithInt:Down]];
            if (![blockedDirections containsObject:[NSNumber numberWithInt:Left]]) [blockedDirections addObject:[NSNumber numberWithInt:Left]];
        }

        if (CGRectContainsPoint(blockingRect, bottomRight)) {
            if (![blockedDirections containsObject:[NSNumber numberWithInt:Down]]) [blockedDirections addObject:[NSNumber numberWithInt:Down]];
            if (![blockedDirections containsObject:[NSNumber numberWithInt:Right]]) [blockedDirections addObject:[NSNumber numberWithInt:Right]];
        }
    }
    return blockedDirections;
}


- (void)moveWithBlockedDirections:(NSArray *)blockedDirections {
    
    MovementDirection moveDirection;
    
    if (_destinationValid) {
        MovementDirection direction = [self destinationMovementDirectionWithInvalidDirections:blockedDirections];
        if (direction != -1) {
            [self moveInDirection:direction];
            if (CGPointEqualToPoint(_destinationPoint, self.position)) {
                [self reachedDestination];
            }
        }
    }
    
    if (arc4random()%10 != 1 && ![blockedDirections containsObject:[NSNumber numberWithInt:_previousMovementDirection]] && _previousMovementDirection != -1) {
        moveDirection = _previousMovementDirection;
    } else {
        NSMutableArray *validMoveDirections = [@[[NSNumber numberWithInt:Left],
                                               [NSNumber numberWithInt:Right],
                                               [NSNumber numberWithInt:Up],
                                               [NSNumber numberWithInt:Down]] mutableCopy];
        
        [validMoveDirections removeObjectsInArray:blockedDirections];
        
        if ([validMoveDirections count] == 0) {
            moveDirection = -1;
        } else {
            moveDirection = [[validMoveDirections objectAtIndex:arc4random()%[validMoveDirections count]] intValue];
        }
    }

    [self moveInDirection:moveDirection];
}


- (void)moveInDirection:(MovementDirection)direction {
    CGRect botFrame = self.frame;
    switch (direction) {
        case Left:
            botFrame.origin.x--;
            break;
            
        case Right:
            botFrame.origin.x++;
            break;
        case Down:
            botFrame.origin.y++;
            break;
            
        case Up:
            botFrame.origin.y--;
            break;
        default:
            break;
    }
    self.frame = botFrame;
    
    _previousMovementDirection = direction;
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


- (MovementDirection)destinationMovementDirectionWithInvalidDirections:(NSArray *)invalidDirections {
    CGFloat yDiff = self.frame.origin.y - _destinationPoint.y;
    CGFloat xDiff = self.frame.origin.x - _destinationPoint.x;
    
    if (xDiff == 0 && yDiff == 0) {
        return -1;
    }
    
    CGFloat absXDiff = fabsf(xDiff);
    CGFloat absYDiff = fabsf(yDiff);
    
    NSInteger randomNum = arc4random()%100;
    CGFloat xProportion = absXDiff/(absXDiff + absYDiff)*100;
    
    MovementDirection direction = -1;
    if ( randomNum < xProportion) {
        if (xDiff < 0) {
            direction = Right;
        } else if (xDiff > 0) {
            direction = Left;
        }
        
        if ([invalidDirections containsObject:[NSNumber numberWithInt:direction]]) {
            direction = -1;
        }
    }
    
    if (randomNum >= xProportion || direction == -1) {
        if (yDiff < 0) {
            direction = Down;
        } else if (yDiff > 0) {
            direction = Up;
        }
        
        if ([invalidDirections containsObject:[NSNumber numberWithInt:direction]]) {
            direction = -1;
        }
    }
    
    return direction;
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
    return sqrt(dx*dx + dy*dy);
}
            
@end
