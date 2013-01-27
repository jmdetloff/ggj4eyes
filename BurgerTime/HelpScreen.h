//
//  HelpScreen.h
//  BurgerTime
//
//  Created by stanza on 1/27/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpScreen : UIViewController
{
    NSDictionary *stash;
}
- (id)initWithLevelParameters:(NSDictionary *)levelParameters;

@end
