//
//  ZapView.m
//  BurgerTime
//
//  Created by John Detloff on 1/27/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "ZapView.h"

@interface Zap : NSObject
@property (nonatomic, assign) CGPoint start;
@property (nonatomic, assign) CGPoint end;
@end
@implementation Zap
@end


@implementation ZapView {
    NSMutableArray *_zaps;
}

+ (id)sharedInstance {
    static ZapView *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZapView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    });
    return sharedInstance;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _zaps = [[NSMutableArray alloc] init];
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)displayZapFrom:(CGPoint)start to:(CGPoint)end {
    Zap *zap = [[Zap alloc] init];
    zap.start = start;
    zap.end = end;
    [_zaps addObject:zap];
    NSTimeInterval delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_zaps removeObject:zap];
        [self setNeedsDisplay];
    });
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(c, [UIColor greenColor].CGColor);
    CGContextBeginPath(c);
    
    for (Zap *zap in _zaps) {
        CGContextMoveToPoint(c, zap.start.x, zap.start.y);
        CGContextAddLineToPoint(c, zap.end.x, zap.end.y);
    }
    CGContextStrokePath(c);
}


@end
