//
//  MovingCollidingGuy.m
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "MovingCollidingGuy.h"

@implementation MovingCollidingGuy {
    MovementDirection _previousMovementDirection;
    CGPoint _destinationPoint;
    BOOL _destinationValid;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


- (NSArray *)blockedDirectionsForBlockingRectangles:(NSArray *)blockingRectangles {
    NSMutableArray *blockedDirections = [[NSMutableArray alloc] init];
    for (NSValue *rectVal in blockingRectangles) {
        CGRect blockingRect = [rectVal CGRectValue];
        CGPoint topLeft = self.frame.origin;
        CGPoint topRight = CGPointMake(CGRectGetMaxX(self.frame), self.frame.origin.y);
        CGPoint bottomLeft = CGPointMake(self.frame.origin.x, CGRectGetMaxY(self.frame));
        CGPoint bottomRight = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
        
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
            if (CGPointEqualToPoint(_destinationPoint, self.frame.origin)) {
                [self reachedDestination];
            }
        }
    }
    
    if (arc4random()%10 != 1 && ![blockedDirections containsObject:[NSNumber numberWithInt:_previousMovementDirection]]) {
        moveDirection = _previousMovementDirection;
    } else {
        NSMutableArray *validMoveDirections = [@[[NSNumber numberWithInt:Left],
                                               [NSNumber numberWithInt:Right],
                                               [NSNumber numberWithInt:Up],
                                               [NSNumber numberWithInt:Down]] mutableCopy];
        
        [validMoveDirections removeObjectsInArray:blockedDirections];
        
        moveDirection = [[validMoveDirections objectAtIndex:arc4random()%[validMoveDirections count]] intValue];
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

@end
