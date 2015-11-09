//
//  GameScene.h
//  Pool
//

//  Copyright (c) 2015 Billy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SetupScene.h"


@interface GameScene : SetupScene

@property BOOL ballIntoPocket;
@property BOOL firstHit;

-(void)whiteBallFallInPocket:(SKSpriteNode*)ball;
-(void)blackBallFallInPocket:(SKSpriteNode*)ball;
-(void)updateScoreOfPlayer;
-(void)pause;
-(void)popupMenuBack;
-(void)yellowBallFallInPocket:(SKSpriteNode*)ball;
-(void)redBallFallInPocket:(SKSpriteNode*)ball;
-(void)whiteBallStopMoving;

@end
