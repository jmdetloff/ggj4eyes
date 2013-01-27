//
//  AudioManagement.m
//  BurgerTime
//
//  Created by stanza on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "AudioManagement.h"

@implementation AudioManagement
+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[AudioManagement alloc] init]; // or some other init method
        [_sharedObject doInitStuff];
    });
    return _sharedObject;
}
-(void)doInitStuff
{
    // Load audio files here
    CFURLRef heartRef  = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"heartbeat" ofType:@"caf"]];
    AudioServicesCreateSystemSoundID(heartRef, &(heartbeatCaf));
    
    CFURLRef momRef  = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"caf"]];
    AudioServicesCreateSystemSoundID(momRef, &(momboCaf));
    
    CFURLRef zapRef  = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"caf"]];
    AudioServicesCreateSystemSoundID(zapRef, &(zapperCaf));
    
    CFURLRef cleanRef  = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"cleaning" ofType:@"caf"]];
    AudioServicesCreateSystemSoundID(cleanRef, &(cleaningCaf));
    
    CFURLRef damageRef  = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"robotdamage" ofType:@"caf"]];
    AudioServicesCreateSystemSoundID(damageRef, &(robotDamageCaf));
    
    CFURLRef pointsRef  = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pointspurchase" ofType:@"caf"]];
    AudioServicesCreateSystemSoundID(pointsRef, &(pointsPurchaseCaf));
    
    CFURLRef clothRef  = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"clothability" ofType:@"caf"]];
    AudioServicesCreateSystemSoundID(clothRef, &(clothCaf));
    
    CFURLRef iconRef  = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"caf"]];
    AudioServicesCreateSystemSoundID(iconRef, &(iconCaf));
    
    
    NSString *s = [[NSBundle mainBundle] pathForResource:@"ingame" ofType:@"caf"];
    backgroundMusic = [[AVAudioPlayer alloc]  initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:s] error:nil];
    [backgroundMusic setDelegate:self];
}

-(id)init  // Don't call me; ask for a sharedInstance -  do *foo = [AudioManagement sharedInstance]
{
    if(self = [super init])
    {
    }
    return self;
}
-(void)playBackground
{

    if(!backgroundMusic.playing)
    {    [backgroundMusic play];   }
}
-(void)stopBackground
{
    [backgroundMusic stop];
}
-(void)playMenuBackground
{
    if(!menuMusic.playing)
    { [menuMusic play]; }
}
-(void)stopMenuBackground
{
    [menuMusic stop];
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [player play];
}
-(void)playCloth
{
    AudioServicesPlaySystemSound(clothCaf);
}
-(void)playIcon
{
    AudioServicesPlaySystemSound(iconCaf);
}
-(void)playPointsPurchase
{
    AudioServicesPlaySystemSound(pointsPurchaseCaf);
}
-(void)playRobotDamage
{
    AudioServicesPlaySystemSound(robotDamageCaf);
}
-(void)playCleaning
{
    AudioServicesPlaySystemSound(cleaningCaf);
}
-(void)playMombo
{
    AudioServicesPlaySystemSound(momboCaf);
}
-(void)playZapper
{
    AudioServicesPlaySystemSound(zapperCaf);
}
-(void)playHeartbeat
{
    AudioServicesPlaySystemSound(heartbeatCaf);
}
@end
