//
//  LPHViewController.m
//  GGJ_RR3
//
//  Created by stanza on 1/26/13.
//  Copyright (c) 2013 Laaph. All rights reserved.
//

#import "LPHViewController.h"

@interface LPHViewController ()

@end

@implementation LPHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
    {
//        NSLog(@"Camera not available :(");
    }
    captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ( [captureDevice isTorchAvailable] && [captureDevice isTorchModeSupported:AVCaptureTorchModeOn]  )
    {
        BOOL success = [captureDevice lockForConfiguration:nil];
        if ( success )
        {
            [captureDevice setTorchMode:AVCaptureTorchModeOn];
            [captureDevice unlockForConfiguration];
        }
    }
    [self initCapture];
}
-(void)viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initCapture
{
    NSError *e = nil;
    AVCaptureDeviceInput *captureInput = nil;
    captureInput = [AVCaptureDeviceInput
                    deviceInputWithDevice: captureDevice
                    error:&e];
    if(e != nil || captureInput == nil)
    {
        NSLog(@"Unable to open camera: %@", e.localizedDescription);
    }
    
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    [captureOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    captureSession = [[AVCaptureSession alloc] init];
    [captureSession addInput:captureInput];
    [captureSession addOutput:captureOutput];
    
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_current_queue()];
    
    // Set the video output to store frame in BGRA (It is supposed to be faster)
	NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
	NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
	NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
	[captureOutput setVideoSettings:videoSettings];
    
    /*We use medium quality, ont the iPhone 4 this demo would be laging too much, the conversion in UIImage and CGImage demands too much ressources for a 720p resolution.*/
    [captureSession setSessionPreset:AVCaptureSessionPresetLow];
    customLayer = [CALayer layer];
    [customLayer setFrame:[[self view] bounds]];
    [[[self view] layer] addSublayer:customLayer];
    
    prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:self->captureSession];
    [prevLayer setFrame:MainImageView.frame];
    [prevLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //  [[[self view] layer] addSublayer:prevLayer];
    
    [captureSession startRunning];
    if(captureSession == nil)
    {
        [Output setText:@"Unable to start video capture session"];
    }
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    /*We create an autorelease pool because as we are not in the main_queue our code is
	 not executed in the main thread. So we have to create an autorelease pool for the thread we are in*/
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // get the average red green and blue values from the image
    
    uint8_t *buf = baseAddress;
    float r=0,g=0,b=0;
    for(int y=0; y<height; y++) {
        for(int x=0; x<width*4; x+=4) {
            b+=buf[x];
            g+=buf[x+1];
            r+=buf[x+2];
        }
        buf+=bytesPerRow;
    }
    r/=255*(float) (width*height);
    g/=255*(float) (width*height);
    b/=255*(float) (width*height);
    
    //NSLog(@"%f,%f,%f", r, g, b);
    [Output setText:[NSString stringWithFormat:@"Red: %f", r]];
    [GraphView addData:r];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef image = CGBitmapContextCreateImage(newContext);
    
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    

    
    UIImage *uiImage = [[UIImage alloc] initWithCGImage:image scale:(CGFloat)1.0 orientation:UIImageOrientationLeftMirrored];
    
    [self->MainImageView setImage:uiImage];
    
//    [uiImage release];
    CGImageRelease(image);
    
    if(image == nil)
    {
        NSLog(@"Unable to get image");
     //   [pool drain];
        return;
    }
    

    
    //[pool drain];
}


- (void)dealloc {
 /*   [MainImageView release];
    [Output release];
    [GraphView release];
    [super dealloc];*/
    
    if ( [captureDevice isTorchAvailable] && [captureDevice isTorchModeSupported:AVCaptureTorchModeOn]  )
    {
        BOOL success = [captureDevice lockForConfiguration:nil];
        if ( success )
        {
            [captureDevice setTorchMode:AVCaptureTorchModeOff];
            [captureDevice unlockForConfiguration];
        }
    }
    [captureSession stopRunning];
 /*   [prevLayer release];
    [captureDevice release];
    [captureSession release];*/
    captureSession = nil;
    captureDevice  = nil;
}

- (void)viewDidUnload {
//    NSLog(@"View unloaded");
  //  [MainImageView release];
    MainImageView = nil;
    //[Output release];
    Output = nil;
    //[GraphView release];
    GraphView = nil;
    [super viewDidUnload];
}
@end
