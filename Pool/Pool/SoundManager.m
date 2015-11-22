//
//  SoundManager.m
//  Pool
//
//  Created by Billy on 13.04.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import "SoundManager.h"

@interface SoundManager()

@end

@implementation SoundManager

+ (id)sharedManager {
    static SoundManager *sharedMyManager = nil;
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
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"bg_music"
                                         ofType:@"mp3"]];
    self.bgPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.bgPlayer.numberOfLoops = -1;
    return self;
}

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
