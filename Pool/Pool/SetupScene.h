//
//  SetupScene.h
//  Pool
//
//  Created by Billy on 06.11.15.
//  Copyright © 2015 Billy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SetupScene : SKScene

@property (nonatomic, strong) SKSpriteNode *whiteBall;
@property (nonatomic, strong) SKSpriteNode *cueStick;
@property (nonatomic, strong) SKSpriteNode *gunSight;
@property (nonatomic, strong) SKLabelNode *shotPowerLabel;
@property (nonatomic, strong) NSNumber *powerSliderValue;
@property (nonatomic, strong) SKLabelNode *scoreLabel;

-(id)initWithSize:(CGSize)size;
-(void)setupWhiteBall;
-(void)drawLine:(CGPoint)point toPoint:(CGPoint)targetPoint;
-(void)setupPlayerNameAndScore;

@end
