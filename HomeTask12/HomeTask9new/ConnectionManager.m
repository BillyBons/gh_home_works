//
//  ConnectionManager.m
//  HomeTask9new
//
//  Created by Billy on 09.02.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "Reachability/Reachability.h"

#import "ConnectionManager.h"

@interface ConnectionManager()

@property (nonatomic, strong) Reachability *reachability;


@end



@implementation ConnectionManager

+(instancetype) connection {
    static dispatch_once_t onceToken;
    static ConnectionManager *manager = nil;
    //NSLog(@"%li", onceToken);
    dispatch_once(&onceToken, ^{
        manager = [[ConnectionManager alloc] init];
    });
    
    return manager;
}

-(instancetype) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    [self.reachability startNotifier];
    
    return self;
}

-(BOOL) isServerReachable {
    return self.reachability.isReachable;
}


@end
