//
//  LivingGuyManager.h
//  BurgerTime
//
//  Created by John Detloff on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LivingGuy <NSObject>
- (void)die;
@end

@protocol DeathDelegate <NSObject>
- (void)viewDied:(UIView *)victim;
- (void)viewWasBornAtPoint:(CGPoint)point;
@end

@interface LivingGuyManager : NSObject

@property (nonatomic, strong) NSMutableArray *bots;
@property (nonatomic, strong) NSMutableArray *enemies;
@property (nonatomic, weak) id<DeathDelegate> deathDelegate;

- (void)livingGuy:(UIView <LivingGuy> *)killer killsLivingGuy:(UIView <LivingGuy> *)victim;
- (void)livingGuyDies:(UIView <LivingGuy> *)victim;
- (void)livingGuyReproduces:(UIView <LivingGuy> *)mom;

@end
