//
//  StaticDataManager.m
//  BurgerTime
//
//  Created by Michel D'Sa on 1/26/13.
//  Copyright (c) 2013 GlobalGameJam. All rights reserved.
//

#import "StaticDataManager.h"

@implementation StaticDataManager

@synthesize classMap, everything, allStaticObjects;

+(StaticDataManager*)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)unpack {
    NSError *error;
    NSString *path;
    NSData *data;
    id obj;
    
    path = [[NSBundle mainBundle] pathForResource:@"class_map" ofType:@"json"];
    data = [NSData dataWithContentsOfFile:path];
    obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (obj) {
        self.classMap = obj;
    }
    
    path = [[NSBundle mainBundle] pathForResource:@"everything" ofType:@"json"];
    data = [NSData dataWithContentsOfFile:path];
    obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (obj) {
        self.everything = obj;
    }
    
    self.allStaticObjects = [NSMutableDictionary dictionary];
    for (NSString *classKey in self.classMap) {
        NSMutableArray *ma = [NSMutableArray array];
        NSString *className = [self.classMap objectForKey:classKey];
        for (NSDictionary *d in [self.everything objectForKey:classKey]) {
            NSObject *newInstance = [[NSClassFromString(className) alloc] init];
            for (NSString *propKey in d) {
                [newInstance setValue:[d objectForKey:propKey] forKey:propKey];
            }
            [ma addObject:newInstance];
        }
        [self.allStaticObjects setObject:ma forKey:classKey];
    }
}

@end
