//
//  TextureManager.m
//  Pool
//
//  Created by Billy on 09.04.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import "TextureManager.h"

@interface TextureManager()

@property (nonatomic, strong) SKTextureAtlas *atlas;

@end


@implementation TextureManager

#pragma mark Singleton Methods

+ (id)sharedManager {
    static TextureManager *sharedMyManager = nil;
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
    self.atlas = [SKTextureAtlas atlasNamed:@"images"];
    return self;
}
    
-(SKTexture*)parket{
    return [self.atlas textureNamed:@"parket"];
}

-(SKTexture*)pocketBallTable{
    return [self.atlas textureNamed:@"pocketBall_table"];
}

-(SKTexture*)blackBall{
    return [self.atlas textureNamed:@"blackBall"];
}

-(SKTexture*)gunsight{
    return [self.atlas textureNamed:@"gunsight"];
}

-(SKTexture*)pockballPoll{
    return [self.atlas textureNamed:@"pockball_poll"];
}

-(SKTexture*)powerSlider{
    return [self.atlas textureNamed:@"power_slider"];
}

-(SKTexture*)psDot{
    return [self.atlas textureNamed:@"ps_dot"];
}

-(SKTexture*)redBall{
    return [self.atlas textureNamed:@"redBall"];
}

-(SKTexture*)whiteBall{
    return [self.atlas textureNamed:@"whiteBall"];
}

-(SKTexture*)yellowBall{
    return [self.atlas textureNamed:@"yellowBall"];
}

@end
