//
//  Nanobot.h
//  BurgerTime
//
//  Created by Michel D'Sa on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Nanobot : NSObject

@property (nonatomic) int pk;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) int hp;
@property (nonatomic) int atk;
@property (nonatomic, strong) NSDictionary *modifiers;

@end
