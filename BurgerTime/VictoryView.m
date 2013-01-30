//
//  VictoryView.m
//  BurgerTime
//
//  Created by John Detloff on 1/27/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "VictoryView.h"
#import "Utils.h"
#import "AppDelegate.h"

@implementation VictoryView {
    int _level;
    UILabel *_pointsLabel;
    UILabel *_totalPoints;
}

- (id)initWithFrame:(CGRect)frame forLevel:(int)level
{
    self = [super initWithFrame:frame];
    if (self) {
        _level = level;
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"Victory.png"];
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImageView *portrait = [[UIImageView alloc] initWithImage:[Utils portraitImageForLevel:_level]];
    portrait.frame = CGRectMake(150 - self.frame.origin.x, 465- self.frame.origin.y,  portrait.frame.size.width, portrait.frame.size.height);
    [self addSubview:portrait];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(218 - self.frame.origin.x, 715 - self.frame.origin.y, 63, 63)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"HomeButton.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"HomeButtonPressed.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    UIButton *restart = [[UIButton alloc] initWithFrame:CGRectMake(333 - self.frame.origin.x, 715 - self.frame.origin.y, 63, 63)];
    [restart setBackgroundImage:[UIImage imageNamed:@"RestartButton.png"] forState:UIControlStateNormal];
    [restart setBackgroundImage:[UIImage imageNamed:@"RestartButtonPressed.png"] forState:UIControlStateHighlighted];
    [restart addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:restart];
    
    UIButton *nextLevel = [[UIButton alloc] initWithFrame:CGRectMake(447 - self.frame.origin.x, 715 - self.frame.origin.y, 63, 63)];
    [nextLevel setBackgroundImage:[UIImage imageNamed:@"NextButton.png"] forState:UIControlStateNormal];
    [nextLevel setBackgroundImage:[UIImage imageNamed:@"NextButtonPressed.png"] forState:UIControlStateHighlighted];
    [nextLevel addTarget:self action:@selector(nextLevel) forControlEvents:UIControlEventTouchUpInside];
    
    if (_level <= 3) {
        [self addSubview:nextLevel];
    }
    
    _pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(362 - 30, 556-self.frame.origin.y, 400, 20)];
    _pointsLabel.backgroundColor = [UIColor clearColor];
    _pointsLabel.textColor = [UIColor whiteColor];
    [self addSubview:_pointsLabel];
    
    _totalPoints = [[UILabel alloc] initWithFrame:CGRectMake(362 - 30, 591-self.frame.origin.y, 400, 20)];
    _totalPoints.backgroundColor = [UIColor clearColor];
    _totalPoints.textColor = [UIColor whiteColor];
    //[self addSubview:_totalPoints];
    
    if (_level <= 2) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:[NSString stringWithFormat:@"level%iunlocked", _level+1]];
        [defaults synchronize];
    }
    
    self.points = 0;
}

- (void)setPoints:(int)points {
    _points = points;
    _pointsLabel.text = [NSString stringWithFormat:@"Points Earned: %i",points];
    
    int totalPoints = [[NSUserDefaults standardUserDefaults] integerForKey:@"totalPoints"];
    _totalPoints.text = [NSString stringWithFormat:@"Total Points Earned: %i",points+totalPoints];
}


- (void)menu {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) showMenu];
}

- (void)restart {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) showLevel:_level];
}

- (void)nextLevel {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) showLevel:_level+1];
}


@end
