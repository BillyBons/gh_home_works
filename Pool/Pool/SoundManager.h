//
//  SoundManager.h
//  Pool
//
//  Created by Billy on 13.04.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SoundManager : SKScene

+(void)playSoundShot1:(SKNode*)node;

+(void)playSoundShot2:(SKNode*)node;

+(void)playSoundFall:(SKNode*)node;

+(void)playSoundBall:(SKNode*)node;

+(void)playSoundEdge:(SKNode*)node;


@end