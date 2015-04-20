//
//  SettingsManager.h
//  Pool
//
//  Created by Billy on 20.04.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SettingsManager : NSObject

+(id)sharedManager;

@property (nonatomic, strong) NSString *soundState;

@end
