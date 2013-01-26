//
//  LPHViewController.h
//  GGJ_RR3
//
//  Created by stanza on 1/26/13.
//  Copyright (c) 2013 Laaph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "LPHGraphView.h"

@interface LPHViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession *captureSession;
    AVCaptureDevice *captureDevice;
    CALayer *customLayer;
    AVCaptureVideoPreviewLayer *prevLayer;
    IBOutlet UIImageView *MainImageView;
    IBOutlet UILabel *Output;
    IBOutlet LPHGraphView *GraphView;

}

@end
