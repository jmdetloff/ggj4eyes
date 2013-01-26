//
//  LPHGraphView.m
//  GGJ_RR3
//
//  Created by stanza on 1/26/13.
//  Copyright (c) 2013 Laaph. All rights reserved.
//

#import "LPHGraphView.h"

@implementation LPHGraphView
-(id)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        [self doInit];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super initWithCoder:aDecoder])
    {
        [self doInit];
    }
    return self;
}
-(void)doInit;
{
    data_size = self.frame.size.width;
    heartData = [[NSMutableArray alloc] initWithCapacity:data_size]; // Doesn't have to be mutable but not dealing with it before coffee
    for(int i = 0; i < data_size; i++)
    {
        [heartData setObject:[NSNumber numberWithDouble:0] atIndexedSubscript:i];
    }
    data_index = 0;
    data_max = 0;
    data_min = 0;
}
-(void)addData:(double)data
{
    NSNumber *tmp = [heartData objectAtIndex:data_index] ;
    double old_data = [tmp doubleValue];
    [heartData setObject:[NSNumber numberWithDouble:data] atIndexedSubscript:data_index];

    if(old_data == data_max || old_data == data_min)
    {
        // scan and reset data_max/data_min.  Not sure if this is the best way but it needs to be done.
        // Or maybe a better way is to reset axes when we go to zero or something
    }
    
    if(data > data_max)
    {
        data_max = data;
    }
    if(data < data_min)
    {
        data_min = data;
    }
    data_index++;
    if(data_index >= data_size)
    {
        data_index = 0;
    }
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect
{
    for(int i = rect.origin.x; i < rect.size.width; i++)
    {
        CGRect line = CGRectMake(i, rect.origin.y, 1, rect.size.height);
        [[UIColor blackColor] set];
        UIRectFill(line);
        NSNumber *p = [heartData objectAtIndex:i];
        double scaled_point = rect.size.height - (([p doubleValue] - .8) * (rect.size.height * 5));
       // NSLog(@"Point: %@  Scaled point: %f", p, scaled_point);
        if(scaled_point > 0)
        {
            CGRect point = CGRectMake(i, scaled_point, 1, 1);
            [[UIColor whiteColor] set];
            UIRectFill(point);
        }
    }
}

@end
