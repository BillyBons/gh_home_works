//
//  ConnectionManager.h
//  HomeTask9new
//
//  Created by Billy on 09.02.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionManager : NSObject

@property (nonatomic, assign, readonly) BOOL isServerConnection;
@property (nonatomic, assign, readwrite) BOOL isServerReachable;

+(instancetype) connection;

@end
