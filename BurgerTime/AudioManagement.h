//
//  AudioManagement.h
//  BurgerTime
//
//  Created by stanza on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface AudioManagement : NSObject <AVAudioPlayerDelegate>
{
    AudioManagement *sharedSingleton;
    
    // Sounds 1
    SystemSoundID iconCaf;
    SystemSoundID clothCaf;
    SystemSoundID pointsPurchaseCaf;
    SystemSoundID robotDamageCaf;
    
    // Sounds 2
    SystemSoundID cleaningCaf;
    SystemSoundID momboCaf;
    SystemSoundID zapperCaf;
    SystemSoundID heartbeatCaf;
    
    // The following is from Sounds 1
    AVAudioPlayer *backgroundMusic;
    AVAudioPlayer *menuMusic;

    
}

+ (id)sharedInstance;

-(void)playMenuBackground;
-(void)stopMenuBackground;
-(void)playBackground;
-(void)stopBackground;
-(void)playIcon;
-(void)playCloth;
-(void)playPointsPurchase;
-(void)playRobotDamage;
-(void)playCleaning;
-(void)playMombo;
-(void)playZapper;
-(void)playHeartbeat;


@end
