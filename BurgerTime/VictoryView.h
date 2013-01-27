//
//  VictoryView.h
//  BurgerTime
//
//  Created by John Detloff on 1/27/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VictoryView : UIImageView

@property (nonatomic,assign) int points;

- (id)initWithFrame:(CGRect)frame forLevel:(int)level;

@end
