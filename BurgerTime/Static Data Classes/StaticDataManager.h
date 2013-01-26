//
//  StaticDataManager.h
//  BurgerTime
//
//  Created by Michel D'Sa on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol StaticDataProtocol <NSObject>
//@required
//
//@end

@interface StaticDataManager : NSObject

@property (nonatomic, strong) NSDictionary *classMap;
@property (nonatomic, strong) NSDictionary *everything;
@property (nonatomic, strong) NSMutableDictionary *allStaticObjects;

+(id)sharedInstance;
-(void)unpack;

@end
