//
//  ZapView.h
//  BurgerTime
//
//  Created by John Detloff on 1/27/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZapView : UIView
+ (id)sharedInstance;
- (void)displayZapFrom:(CGPoint)start to:(CGPoint)end;
@end
