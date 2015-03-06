//
//  GameScene.m
//  Pool
//
//  Created by Billy on 06.03.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self initWithSize:CGSizeMake(568, 320)];
    [self BouncingBall];
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
//        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
//        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//        [self addChild:background];
    }
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    /* Called when a touch begins */
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    SKPhysicsBody* body = [self.physicsWorld bodyAtPoint:touchLocation];
    if (body && [body.node.name isEqualToString: @"Cue"]) {
        NSLog(@"Began touch on paddle");
        self.isFingerOnCue = YES;
    }
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{
    // 1 Check whether user tapped paddle
    if (self.isFingerOnCue) {
        // 2 Get touch location
        UITouch* touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        // 3 Get node for cue
        SKShapeNode* cue = (SKShapeNode*)[self childNodeWithName: @"Cue"];
        // 4 Calculate new position along x for cue
        int cueX = cue.position.x + (touchLocation.x - previousLocation.x);
        int cueY = cue.position.y + (previousLocation.y - touchLocation.y);
        // 5 Limit x so that the cue will not leave the screen to left or right
        //cueX = MAX(cueX, cue.size.width/2);
        //cueX = MIN(cueX, self.size.width - cue.size.width/2);
        // 6 Update position of paddle
        cue.position = CGPointMake(cueX, cueY);
    }}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event{
    self.isFingerOnCue = NO;
}

-(void)BouncingBall{
    // 1 Create a physics body that borders the screen
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    // 2 Set physicsBody of scene to borderBody
    self.physicsBody = borderBody;
    // 3 Set the friction of that physicsBody to 0
    self.physicsBody.friction = 0.0f;
    
    SKSpriteNode* ball = [SKSpriteNode spriteNodeWithImageNamed: @"ball_white.png"];
    ball.name = @"ball";
    ball.position = CGPointMake(self.frame.size.width/5, self.frame.size.height/2);
    [self addChild:ball];
    
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    ball.physicsBody.friction = 0.1f;
    ball.physicsBody.restitution = 1.0f;
    ball.physicsBody.linearDamping = 0.1f;
    ball.physicsBody.allowsRotation = NO;
    
    
    [ball.physicsBody applyImpulse:CGVectorMake(10.0f, 1.5f)];
    
    
    SKSpriteNode* ball2 = [SKSpriteNode spriteNodeWithImageNamed: @"ball_green.png"];
    ball2.name = @"ball2";
    ball2.position = CGPointMake(self.frame.size.width/2 + 25, self.frame.size.height/2 + 15);
    [self addChild:ball2];
    
    ball2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball2.frame.size.width/2];
    ball2.physicsBody.friction = 0.1f;
    ball2.physicsBody.restitution = 1.0f;
    ball2.physicsBody.linearDamping = 0.1f;
    ball2.physicsBody.allowsRotation = NO;
    
    
    SKSpriteNode* ball3 = [SKSpriteNode spriteNodeWithImageNamed: @"ball_red.png"];
    ball3.name = @"ball3";
    ball3.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:ball3];
    
    ball3.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball3.frame.size.width/2];
    ball3.physicsBody.friction = 0.1f;
    ball3.physicsBody.restitution = 1.0f;
    ball3.physicsBody.linearDamping = 0.1f;
    ball3.physicsBody.allowsRotation = NO;
    
    
    SKSpriteNode* ball4 = [SKSpriteNode spriteNodeWithImageNamed: @"ball_yellow.png"];
    ball4.name = @"ball4";
    ball4.position = CGPointMake(self.frame.size.width/2 + 25, self.frame.size.height/2 - 15);
    [self addChild:ball4];
    
    ball4.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball4.frame.size.width/2];
    ball4.physicsBody.friction = 0.1f;
    ball4.physicsBody.restitution = 1.0f;
    ball4.physicsBody.linearDamping = 0.1f;
    ball4.physicsBody.allowsRotation = NO;
    
    
    SKShapeNode *cue = [SKShapeNode shapeNodeWithRect:CGRectMake(-80/2, -3, 80, 6)];
    cue.name = @"Cue";
    cue.position = CGPointMake(20, 160);
    cue.strokeColor = [SKColor redColor];
    cue.fillColor = [SKColor greenColor];
    [self addChild:cue];
    cue.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:cue.frame.size];
    cue.physicsBody.restitution = 0.9f;
    cue.physicsBody.friction = 0.4f;
    // make physicsBody static
    cue.physicsBody.dynamic = NO;
 
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end