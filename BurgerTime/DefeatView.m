//
//  DefaultView.m
//  BurgerTime
//
//  Created by John Detloff on 1/27/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "DefeatView.h"
#import "Utils.h"
#import "AppDelegate.h"

@implementation DefeatView {
    int _level;
    UILabel *_waveLabel;
}

- (id)initWithFrame:(CGRect)frame forLevel:(int)level
{
    self = [super initWithFrame:frame];
    if (self) {
        _level = level;
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"Defeat.png"];
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImageView *portrait = [[UIImageView alloc] initWithImage:[Utils deadPortraitImageForLevel:_level]];
    portrait.frame = CGRectMake(150 - self.frame.origin.x, 465- self.frame.origin.y,  portrait.frame.size.width, portrait.frame.size.height);
    [self addSubview:portrait];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(281 - self.frame.origin.x, 715 - self.frame.origin.y, 63, 63)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"HomeButton.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"HomeButtonPressed.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    UIButton *restart = [[UIButton alloc] initWithFrame:CGRectMake(397 - self.frame.origin.x, 715 - self.frame.origin.y, 63, 63)];
    [restart setBackgroundImage:[UIImage imageNamed:@"RestartButton.png"] forState:UIControlStateNormal];
    [restart setBackgroundImage:[UIImage imageNamed:@"RestartButtonPressed.png"] forState:UIControlStateHighlighted];
    [restart addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:restart];
    
    _waveLabel = [[UILabel alloc] initWithFrame:CGRectMake(362 - 30, 556-self.frame.origin.y, 400, 20)];
    _waveLabel.backgroundColor = [UIColor clearColor];
    _waveLabel.textColor = [UIColor whiteColor];
    _waveLabel.font = [UIFont fontWithName:@"Hooge0557" size:20];
    [self addSubview:_waveLabel];
    
    self.wave = 0;
}


- (void)setWave:(int)wave {
    _wave = wave;
    _waveLabel.text = [NSString stringWithFormat:@"You survived until Wave: %i",wave];
}


- (void)menu {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) showMenu];
}

- (void)restart {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) showLevel:_level];
}


@end
