//
//  MenuViewController.m
//  BurgerTime
//
//  Created by John Detloff on 1/27/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "AudioManagement.h"
#import "StaticDataManager.h"

@interface MenuViewController ()

@end

@implementation MenuViewController {
    UIButton *_level1;
    UIButton *_level2;
    UIButton *_level3;
    UIImageView *_popover;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //load static data from json
    [[StaticDataManager sharedInstance] unpack];

    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomescreenBG.png"]];
    background.frame = self.view.bounds;
    [self.view addSubview:background];
    
    _level1 = [[UIButton alloc] initWithFrame:CGRectMake(61, 286, 187, 216)];
    _level1.tag = 1;
    [_level1 addTarget:self action:@selector(selectedLevel:) forControlEvents:UIControlEventTouchUpInside];
    [_level1 setBackgroundImage:[UIImage imageNamed:@"Level1Portrait.png"] forState:UIControlStateNormal];
    [self.view addSubview:_level1];
    
    _level2 = [[UIButton alloc] initWithFrame:CGRectMake(290, 286, 187, 216)];
    _level2.tag = 2;
    _level2.adjustsImageWhenDisabled = NO;
    [_level2 addTarget:self action:@selector(selectedLevel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_level2];
    
    _level3 = [[UIButton alloc] initWithFrame:CGRectMake(519, 286, 187, 216)];
    _level3.tag = 3;
    _level3.adjustsImageWhenDisabled = NO;
    [_level3 addTarget:self action:@selector(selectedLevel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_level3];
    
    [self updateButtonImages];
    
    UIButton *instructionsButton = [[UIButton alloc] initWithFrame:CGRectMake(440, 698, 254, 64)];
    [instructionsButton addTarget:self action:@selector(instructions) forControlEvents:UIControlEventTouchUpInside];
    [instructionsButton setBackgroundImage:[UIImage imageNamed:@"InstructionsButton.png"] forState:UIControlStateNormal];
    [instructionsButton setBackgroundImage:[UIImage imageNamed:@"InstructionsButtonPressed.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:instructionsButton];
    
    UIButton *creditsButton = [[UIButton alloc] initWithFrame:CGRectMake(440, 803, 254, 64)];
    [creditsButton addTarget:self action:@selector(credits) forControlEvents:UIControlEventTouchUpInside];
    [creditsButton setBackgroundImage:[UIImage imageNamed:@"CreditsButton.png"] forState:UIControlStateNormal];
    [creditsButton setBackgroundImage:[UIImage imageNamed:@"CreditsButtonPressed.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:creditsButton];
    
    [[AudioManagement sharedInstance] playMenuBackground];
}


- (void)instructions {
    [[AudioManagement sharedInstance] playIcon];
    _popover = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _popover.userInteractionEnabled = YES;
    _popover.image = [UIImage imageNamed:@"InstructionsBG.png"];
    [self.view addSubview:_popover];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(52, 45, 63, 63)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"HomeButton.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"HomeButtonPressed.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(closePopover) forControlEvents:UIControlEventTouchUpInside];
    [_popover addSubview:backButton];
}


- (void)credits {
    [[AudioManagement sharedInstance] playIcon];
    _popover = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _popover.userInteractionEnabled = YES;
    _popover.image = [UIImage imageNamed:@"CreditsBG.png"];
    [self.view addSubview:_popover];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(52, 45, 63, 63)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"HomeButton.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"HomeButtonPressed.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(closePopover) forControlEvents:UIControlEventTouchUpInside];
    [_popover addSubview:backButton];
}


- (void)closePopover {
    if (_popover) {
        [[AudioManagement sharedInstance] playIcon];
        [_popover removeFromSuperview];
        _popover = nil;
    }
}


- (void)updateButtonImages {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL level2 = [defaults boolForKey:@"level2unlocked"];
    BOOL level3 = [defaults boolForKey:@"level3unlocked"];
    
    if (level2) {
        _level2.enabled = YES;
        [_level2 setBackgroundImage:[UIImage imageNamed:@"Level2Portrait.png"] forState:UIControlStateNormal];
    } else {
        _level2.enabled = NO;
        [_level2 setBackgroundImage:[UIImage imageNamed:@"Level2PortraitLocked.png"] forState:UIControlStateNormal];
    }
    
    if (level3) {
        _level3.enabled = YES;
        [_level3 setBackgroundImage:[UIImage imageNamed:@"Level3Portrait.png"] forState:UIControlStateNormal];
    } else {
        _level3.enabled = NO;
        [_level3 setBackgroundImage:[UIImage imageNamed:@"Level3PortraitLocked.png"] forState:UIControlStateNormal];
    }
}


- (void)selectedLevel:(UIButton *)levelButton {
    [[AudioManagement sharedInstance] playIcon];
    [[AudioManagement sharedInstance] stopMenuBackground];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) showHelp:levelButton.tag];
}


@end
