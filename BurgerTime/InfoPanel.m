//
//  InfoPanel.m
//  BurgerTime
//
//  Created by John Detloff on 1/27/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "InfoPanel.h"

@implementation InfoPanel {
    UILabel *_fightCountLabel;
    UILabel *_healCountLabel;
    UILabel *_cleanCountLabel;
    UILabel *_neutralCountLabel;
    UILabel *_waveCountLabel;
    UILabel *_pointsCountLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"InfoBar.png"];
        [self setup];
    }
    return self;
}

- (void)setup {
    UIFont *f =  [UIFont fontWithName:@"Hooge0557" size:20];
    
    _fightCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(74 - self.frame.origin.x, 53, 40, 23)];
    _fightCountLabel.backgroundColor = [UIColor clearColor];
    _fightCountLabel.textColor = [UIColor whiteColor];
    [self addSubview:_fightCountLabel];
    
    _healCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(129- self.frame.origin.x, 53, 40, 23)];
    _healCountLabel.backgroundColor = [UIColor clearColor];
    _healCountLabel.textColor = [UIColor whiteColor];
    [self addSubview:_healCountLabel];
    
    _cleanCountLabel= [[UILabel alloc] initWithFrame:CGRectMake(184- self.frame.origin.x, 53, 40, 23)];
    _cleanCountLabel.backgroundColor = [UIColor clearColor];
    _cleanCountLabel.textColor = [UIColor whiteColor];
    [self addSubview:_cleanCountLabel];
    
    _neutralCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(238- self.frame.origin.x, 53, 40, 23)];
    _neutralCountLabel.backgroundColor = [UIColor clearColor];
    _neutralCountLabel.textColor = [UIColor whiteColor];
    [self addSubview:_neutralCountLabel];
    
    _waveCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 19, 60, 23)];
    _waveCountLabel.backgroundColor = [UIColor clearColor];
    _waveCountLabel.textColor = [UIColor whiteColor];
    [self addSubview:_waveCountLabel];
    
    _pointsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(184, 19, 80, 23)];
    _pointsCountLabel.backgroundColor = [UIColor clearColor];
    _pointsCountLabel.textColor = [UIColor whiteColor];
    [self addSubview:_pointsCountLabel];
    
    _fightCountLabel.font = f;
    _healCountLabel.font = f;
    _cleanCountLabel.font = f;
    _neutralCountLabel.font = f;
    _waveCountLabel.font = f;
    _pointsCountLabel.font = f;
    
    self.wave = 0;
    self.points = 60;
    self.fighterCount = 0;
    self.healCount = 0;
    self.cleanerCount = 0;
    self.neutralCount = 0;
}

- (void)setWave:(int)wave {
    _wave = wave;
    _waveCountLabel.text = [NSString stringWithFormat:@"%i", wave];
}

- (void)setPoints:(int)points {
    _points = points;
    _pointsCountLabel.text = [NSString stringWithFormat:@"%i", points];
}

- (void)setFighterCount:(int)fighters {
    _fighterCount = fighters;
    _fightCountLabel.text = [NSString stringWithFormat:@"%i", fighters];
}

- (void)setHealCount:(int)healers {
    _healCount = healers;
    _healCountLabel.text = [NSString stringWithFormat:@"%i", healers];
}

- (void)setCleanerCount:(int)cleaners {
    _cleanerCount = cleaners;
    _cleanCountLabel.text = [NSString stringWithFormat:@"%i", cleaners];
}

- (void)setNeutralCount:(int)neutrals {
    if (neutrals == 0) {
        NSLog(@"test");
    }
    
    _neutralCount = neutrals;
    _neutralCountLabel.text = [NSString stringWithFormat:@"%i", neutrals];
}

@end
