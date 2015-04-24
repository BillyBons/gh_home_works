//
//  GameScene.h
//  Pool
//

//  Copyright (c) 2015 Billy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

@property BOOL ballFallIntoPocket;

-(void)setupPlayerNameAndScore;
-(void)whiteBallFallInPocket:(SKSpriteNode*)ball;
-(void)blackBallFallInPocket:(SKSpriteNode*)ball;
-(void)updateScoreOfPlayer;
-(void)pause;
-(void)popupMenuBack;
-(void)yellowBallFallInPocket:(SKSpriteNode*)ball;
-(void)redBallFallInPocket:(SKSpriteNode*)ball;
-(void)whiteBallStopped;



@end
