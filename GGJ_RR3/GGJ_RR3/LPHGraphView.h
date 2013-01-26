//
//  LPHGraphViewController.h
//  GGJ_RR3
//
//  Created by stanza on 1/26/13.
//  Copyright (c) 2013 Laaph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPHGraphView : UIView
{
    NSMutableArray *heartData;
    int data_size;
    int data_index;
    double data_max;
    double data_min;
}
-(void)addData:(double)data;

@end
