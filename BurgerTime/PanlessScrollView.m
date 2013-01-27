//
//  PanlessScrollView.m
//  BurgerTime
//
//  Created by John Detloff on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "PanlessScrollView.h"

@implementation PanlessScrollView

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
	if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
	{
		gestureRecognizer.enabled = NO;
	}
    
	[super addGestureRecognizer:gestureRecognizer];
}

@end
