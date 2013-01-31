//
//  PrototypeViewController.h
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPowerRadius 80
#define kFullHealth 1500
#define kFullHealthbarLength 95
#define kMaxMomSpawn 15

@interface PrototypeViewController : UIViewController
{
    float scaleFactor;
}

- (id)initWithLevelParameters:(NSDictionary *)levelParameters;


@end
