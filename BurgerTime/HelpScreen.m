//
//  HelpScreen.m
//  BurgerTime
//
//  Created by stanza on 1/27/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "HelpScreen.h"
#import "AppDelegate.h"


@implementation HelpScreen
- (id)initWithLevelParameters:(NSDictionary *)levelParameters
{
    if(self = [super init])
    {
        stash = levelParameters;
    }
    return self;
}
-(void)viewDidLoad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL tipsHaveBeenShown = [defaults boolForKey:@"tipsHaveBeenShown"];
    
    if(tipsHaveBeenShown)
    {
        
        [self pressMe];
    }
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    background.frame = self.view.bounds;
   
    UIImageView *popupWindow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"InstructionsPopup.png"]];
    popupWindow.frame = CGRectMake(50, 300, 667, 447);
    
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(pressMe) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"ClosePopupButton.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(687, 270, 59, 59)];
    
    [[self view] addSubview:background];
    [[self view] addSubview:popupWindow];
    [[self view] addSubview:button];
}
-(void)pressMe
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     
    [defaults setBool:true forKey:@"tipsHaveBeenShown"];
    [defaults synchronize];
    
//    NSLog(@"default is %i", [defaults boolForKey:@"tipsHaveBeenShown"]);
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) showLevel:[stash[@"levelNum"] intValue]];
}
@end
