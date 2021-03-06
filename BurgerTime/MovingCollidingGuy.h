//
//  MovingCollidingGuy.h
//  BurgerTime
//
//  Created by John Detloff on 1/25/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LivingGuyManager;

@protocol DestinationDelegate <NSObject>
- (void)destinationReached:(id)sender;
@end

typedef enum {
    Left,
    Right,
    Up,
    Down
} MovementDirection;


@interface MovingCollidingGuy : UIView
@property (nonatomic, strong) id swipeKey;
@property (nonatomic, weak) id<DestinationDelegate> enemyKey;
@property (nonatomic, strong) LivingGuyManager *livingGuyManager;
- (void)setDestinationPoint:(CGPoint)destinationPoint;
- (void)clearDestination;

@property (nonatomic) float angle;
@property (nonatomic) float velocity;
@property (nonatomic) CGPoint position;

//"scrub" action
@property (nonatomic) int cycleState;
@property (nonatomic) CGPoint cyclePivot;
@property (nonatomic) CGPoint cycleParticleStart;
@property (nonatomic) float cycleRadius;
@property (nonatomic, assign) BOOL moves;

- (void)advance:(double)dt;
- (CGPoint)nextPos:(double)dt withAngle:(float)ang;
- (void)rerollAngle:(double)dt;
- (void)orderCycleWithPivot:(CGPoint)pivot_ radius:(float)radius_;
- (void)collided:(double)dt;
- (void)stopCycling;
- (BOOL)setOptionalDestinationPoint:(CGPoint)destinationPoint;

@end
