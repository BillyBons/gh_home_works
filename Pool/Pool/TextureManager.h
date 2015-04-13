//
//  TextureManager.h
//  Pool
//
//  Created by Billy on 09.04.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface TextureManager : NSObject

+ (id)sharedManager;

-(SKTexture*)parket;

-(SKTexture*)pocketBallTable;

-(SKTexture*)blackBall;

-(SKTexture*)gunsight;

-(SKTexture*)pockballPoll;

-(SKTexture*)powerSlider;

-(SKTexture*)psDot;

-(SKTexture*)redBall;

-(SKTexture*)whiteBall;

-(SKTexture*)yellowBall;

@end
