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

    CGRect botFrame = self.frame;
    switch (moveDirection) {
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
    
    _previousMovementDirection = moveDirection;
}


@end
