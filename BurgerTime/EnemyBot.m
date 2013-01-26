//
//  EnemyBot.m
//  BurgerTime
//
//  Created by stanza on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "EnemyBot.h"

@implementation EnemyBot
@synthesize botType;
@synthesize hp;
@synthesize atk;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        botType = arc4random() % 5;
        hp = 20;
        atk = 20;
        // Probably not what we want to do.
    }
    return self;
}
-(NSString *)name
{
    switch (botType) {
        case ENDOCARDITIS:
            return @"Endocarditus";
        case MYOCARDITIS:
            return @"Myocarditis";
        case ATHEROSCLEROSIS:
            return @"Atherosclerosis";
        case ISCHAEMIA:
            return @"Ischaemia";
        case CARDIOMYOPATHY:
            return @"Cardiomyopathy";
    }
}
-(UIColor *)color
{
    switch(botType) {
        case ENDOCARDITIS:
            return [UIColor blackColor];
        case MYOCARDITIS:
            return [UIColor redColor];
        case ATHEROSCLEROSIS:
            return [UIColor greenColor];
        case ISCHAEMIA:
            return [UIColor blueColor];
        case CARDIOMYOPATHY:
            return [UIColor yellowColor];
    }
}

@end
