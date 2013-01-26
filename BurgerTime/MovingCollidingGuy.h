//
//  MovingCollidingGuy.h
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Left,
    Right,
    Up,
    Down
} MovementDirection;


@interface MovingCollidingGuy : UIView
- (void)setDestinationPoint:(CGPoint)destinationPoint withDuration:(NSTimeInterval)duration;
- (void)moveWithBlockedDirections:(NSArray *)blockedDirections;
- (NSArray *)blockedDirectionsForBlockingRectangles:(NSArray *)blockingRectangles;
@end
