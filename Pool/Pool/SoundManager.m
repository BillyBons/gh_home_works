//
//  SoundManager.m
//  Pool
//
//  Created by Billy on 13.04.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

+(void)playSoundShot1:(SKNode*)node {
    [node runAction:[SKAction playSoundFileNamed:@"Shot01.wav" waitForCompletion:NO]];
}

+(void)playSoundShot2:(SKNode*)node {
    [node runAction:[SKAction playSoundFileNamed:@"Shot02.wav" waitForCompletion:NO]];
}

+(void)playSoundFall:(SKNode*)node {
    [node runAction:[SKAction playSoundFileNamed:@"Fall.wav" waitForCompletion:NO]];
}

+(void)playSoundBall:(SKNode*)node {
    [node runAction:[SKAction playSoundFileNamed:@"Ball.wav" waitForCompletion:NO]];
}

+(void)playSoundEdge:(SKNode*)node {
    [node runAction:[SKAction playSoundFileNamed:@"Edge.wav" waitForCompletion:NO]];
}

@end
