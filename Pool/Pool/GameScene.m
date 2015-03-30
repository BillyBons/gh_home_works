//
//  GameScene.m
//  Pool
//
//  Created by Billy on 06.03.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import "GameScene.h"

static const uint32_t ballCategory = 0x1 << 0;

static const uint32_t cueCategory = 0x1 << 1;

static const uint32_t borderCategory = 0x1 << 2;

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.physicsWorld.contactDelegate = self;
    
    //[self initWithSize:CGSizeMake(568, 320)];
    
    [self BouncingBall];
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1 Create local variables for two physics bodies
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    NSLog(@"Contact point x = %f, y = %f", contact.contactPoint.x, contact.contactPoint.y);
    
    // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == borderCategory) {
        NSLog(@"Hit border!!!");
        [self runAction:[SKAction playSoundFileNamed:@"Bank02.wav" waitForCompletion:NO]];
    }
    if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == cueCategory) {
       
        
        
        [self runAction:[SKAction playSoundFileNamed:@"Shot01.wav" waitForCompletion:NO]];
        
        if ([firstBody.node.name isEqualToString:@"ball"]){
        SKShapeNode* ball = (SKShapeNode*)[self childNodeWithName: @"ball"];
        [ball.physicsBody applyImpulse:CGVectorMake(20.0f, 1.0f)];
        [secondBody.node removeFromParent];
        }
        
    }
    
    if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == ballCategory) {
        NSLog(@"Hit ball!!!");
        [self runAction:[SKAction playSoundFileNamed:@"Hit04.wav" waitForCompletion:NO]];
    }
    
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:background];
        self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    }
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    /* Called when a touch begins */
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    NSLog(@"touch x = %f,  touch y = %f,",touchLocation.x, touchLocation.y);
    SKPhysicsBody* body = [self.physicsWorld bodyAtPoint:touchLocation];
    if (body && [body.node.name isEqualToString: @"Cue"]) {
        NSLog(@"Began touch on cue");
        self.isFingerOnCue = YES;
        
    }
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{
    // 1 Check whether user tapped cue
    if (self.isFingerOnCue) {
        // 2 Get touch location
        
        UITouch* touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInNode:self];
        
        // 3 Get node for cue
        SKShapeNode* cue = (SKShapeNode*)[self childNodeWithName: @"Cue"];
       
        
        // 4 Calculate new position along x for cue
        int cueX = touchLocation.x;
        int cueY = touchLocation.y;
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
    self.physicsBody.categoryBitMask = borderCategory;
    self.physicsBody.contactTestBitMask = ballCategory;
    // 3 Set the friction of that physicsBody to 0
    self.physicsBody.friction = 0.0f;
    
    
    
    SKSpriteNode* ball = [SKSpriteNode spriteNodeWithImageNamed: @"ball_white.png"];
    ball.name = @"ball";
    ball.position = CGPointMake(self.frame.size.width/3, self.frame.size.height/2);
    [self addChild:ball];
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    ball.physicsBody.friction = 3.0f;
    ball.physicsBody.restitution = 1.0f;
    ball.physicsBody.linearDamping = 0.1f;
    ball.physicsBody.allowsRotation = NO;
    
    ball.physicsBody.categoryBitMask = ballCategory;
    ball.physicsBody.contactTestBitMask = ballCategory;
    //ball.physicsBody.collisionBitMask = borderCategory;
    
    //[ball.physicsBody applyImpulse:CGVectorMake(20.0f, 1.5f)];
    
    
    SKSpriteNode* ball2 = [SKSpriteNode spriteNodeWithImageNamed: @"ball_green.png"];
    ball2.name = @"ball2";
    ball2.position = CGPointMake(self.frame.size.width/2 + 27, self.frame.size.height/2 + 16);
    [self addChild:ball2];
    ball2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball2.frame.size.width/2];
    ball2.physicsBody.friction = 3.0f;
    ball2.physicsBody.restitution = 1.0f;
    ball2.physicsBody.linearDamping = 0.1f;
    ball2.physicsBody.allowsRotation = NO;
    ball2.physicsBody.categoryBitMask = ballCategory;
    ball2.physicsBody.contactTestBitMask = ballCategory;
    //ball2.physicsBody.collisionBitMask = borderCategory;
    
    SKSpriteNode* ball3 = [SKSpriteNode spriteNodeWithImageNamed: @"ball_red.png"];
    ball3.name = @"ball3";
    ball3.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:ball3];
    ball3.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball3.frame.size.width/2];
    ball3.physicsBody.friction = 3.0f;
    ball3.physicsBody.restitution = 1.0f;
    ball3.physicsBody.linearDamping = 0.1f;
    ball3.physicsBody.allowsRotation = NO;
    ball3.physicsBody.categoryBitMask = ballCategory;
    ball3.physicsBody.contactTestBitMask = ballCategory;
    //ball3.physicsBody.collisionBitMask = borderCategory;
    
    SKSpriteNode* ball4 = [SKSpriteNode spriteNodeWithImageNamed: @"ball_yellow.png"];
    ball4.name = @"ball4";
    ball4.position = CGPointMake(self.frame.size.width/2 + 27, self.frame.size.height/2 - 16);
    [self addChild:ball4];
    ball4.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball4.frame.size.width/2];
    ball4.physicsBody.friction = 3.0f;
    ball4.physicsBody.restitution = 1.0f;
    ball4.physicsBody.linearDamping = 0.1f;
    ball4.physicsBody.allowsRotation = NO;
    ball4.physicsBody.categoryBitMask = ballCategory;
    ball4.physicsBody.contactTestBitMask = ballCategory;
    //ball4.physicsBody.collisionBitMask = borderCategory;
    
    SKSpriteNode *cue = [SKSpriteNode spriteNodeWithImageNamed: @"Cue.png"];
    cue.name = @"Cue";
    cue.position = CGPointMake(60, self.frame.size.height/2);
    cue.physicsBody.restitution = 0.9f;
    cue.physicsBody.friction = 0.4f;
    cue.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:cue.frame.size];
    cue.physicsBody.dynamic = NO;
    
    cue.physicsBody.categoryBitMask = cueCategory;
    cue.physicsBody.contactTestBitMask = ballCategory;
    cue.physicsBody.collisionBitMask = ballCategory;
    
    [self addChild:cue];
    //ball.zRotation = 14;
    
    //SKPhysicsJointSpring *cueBall = [SKPhysicsJointSpring jointWithBodyA:cue.physicsBody bodyB:ball.physicsBody anchorA:CGPointMake(10, self.frame.size.height/2) anchorB:CGPointMake(self.frame.size.width/3, self.frame.size.height/2)];
    //SKPhysicsJointPin *cueBall2 = [SKPhysicsJointPin jointWithBodyA:ball.physicsBody bodyB:cue.physicsBody anchor:CGPointMake(self.frame.size.width/3, self.frame.size.height/2)];
    //SKPhysicsJointLimit *cueBall3 = [SKPhysicsJointLimit jointWithBodyA:cue2 bodyB:ball1 anchorA:CGPointMake(10, self.frame.size.height/2) anchorB:CGPointMake(self.frame.size.width/3, self.frame.size.height/2)];
    
    //[self.physicsWorld addJoint:cueBall2];
   
    
}

-(void)update:(CFTimeInterval)currentTime {
    
    //SKShapeNode* ball = (SKShapeNode*)[self childNodeWithName: @"ball"];
    //NSLog(@"%f, %f", ball.position.x, ball.position.y);
    
    /* Called before each frame is rendered */
}

@end
