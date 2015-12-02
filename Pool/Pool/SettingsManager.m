//
//  SettingsManager.m
//  Pool
//
//  Created by Billy on 20.04.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import "SettingsManager.h"

@implementation SettingsManager

#pragma mark Singleton Methods

+ (id)sharedManager {
    static SettingsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(instancetype)init {
    self = [super init];
    if (!self){
        return nil;
    }
    self.soundEffectsState = YES;
    self.bgMusicState = YES;
    return self;
}

@end
