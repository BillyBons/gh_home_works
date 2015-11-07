//
//  SetupScene.m
//  Pool
//
//  Created by Billy on 06.11.15.
//  Copyright © 2015 Billy. All rights reserved.
//

#import "SetupScene.h"
#import "TextureManager.h"
#import "SoundManager.h"
#import "MainMenu.h"
#import "GameScene.h"

typedef NS_OPTIONS (NSInteger, ContactPhysicsBodyes){
    ContactPhysicsBodyEdge = 1 << 0,
    ContactPhysicsBodyBall = 1 << 1,
    ContactPhysicsBodyPocket = 1 << 2,
};

const CGFloat ball_Radius = 10.0f;

@interface SetupScene()

@property (nonatomic, weak) TextureManager *textureManager;

@end

@implementation SetupScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self initBackGroundView];
        
    }
    return self;
}

-(void)initBackGroundView {
    self.powerSliderValue = @100;
    self.textureManager = [TextureManager sharedManager];
    [self setupBackgrounds];
    [self setupTablePhysicsEdge];
    [self setupBalls];
    [self setupWhiteBall];
    [self setupPowerSlider];
    [self setupCueStick];
    [self setupTriangle];
    [self setupGunSight];
    [self setupShotOfPowerLabel];
    [self setupMenuAndScore];
}

-(void)setupBackgrounds {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:[self.textureManager tableBg]];
    background.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:background];
    
    SKSpriteNode *bgTable = [SKSpriteNode spriteNodeWithTexture:[self.textureManager pocketBallTable]];
    bgTable.position = CGPointMake(self.size.width/2-25, self.size.height/2-12);
    [self addChild:bgTable];
}

-(void)setupTablePhysicsEdge{
    for (int i = 0; i < 6; i++) {
        float sizeA = 0.0;
        float sizeB = 0.0;
        float positionX = 0.0;
        float positionY = 0.0;
        switch (i) {
            case 0:
                sizeA = 1;
                sizeB = 188;
                positionX = 36;
                positionY = 148;
                break;
            case 1:
                sizeA = 193;
                sizeB = 1;
                positionX = 149;
                positionY = 260;
                break;
            case 2:
                sizeA = 193;
                sizeB = 1;
                positionX = 369;
                positionY = 260;
                break;
            case 3:
                sizeA = 1;
                sizeB = 188;
                positionX = 482;
                positionY = 148;
                break;
            case 4:
                sizeA = 193;
                sizeB = 1;
                positionX = 149;
                positionY = 36;
                break;
            case 5:
                sizeA = 193;
                sizeB = 1;
                positionX = 369;
                positionY = 36;
                break;
            default:
                break;
        }
        SKSpriteNode *insideEdge = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(sizeA, sizeB)];
        insideEdge.position = CGPointMake(positionX, positionY);
        insideEdge.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:insideEdge.size];
        insideEdge.physicsBody.dynamic = NO;
        insideEdge.physicsBody.categoryBitMask = ContactPhysicsBodyEdge;
        insideEdge.physicsBody.collisionBitMask = ContactPhysicsBodyBall;
        insideEdge.physicsBody.contactTestBitMask = ContactPhysicsBodyBall;
        insideEdge.physicsBody.restitution = 0.5;
        [self addChild:insideEdge];
    }
    
    for (int i = 0; i < 8; i++) {
        float sizeA = 12.0;
        float sizeB = 1.0;
        float positionX = 0.0;
        float positionY = 0.0;
        float zRotationAngle = 0.0;
        switch (i) {
            case 0:
                positionX = 49;
                positionY = 264;
                zRotationAngle = M_PI*0.75;
                break;
            case 1:
                positionX = 31;
                positionY = 247;
                zRotationAngle = M_PI*0.75;
                break;
            case 2:
                positionX = 31;
                positionY = 50;
                zRotationAngle = M_PI_4;
                break;
            case 3:
                positionX = 49;
                positionY = 32;
                zRotationAngle = M_PI_4;
                break;
            case 4:
                positionX = 469;
                positionY = 264;
                zRotationAngle = M_PI_4;
                break;
            case 5:
                positionX = 487;
                positionY = 247;
                zRotationAngle = M_PI_4;
                break;
            case 6:
                positionX = 487;
                positionY = 50;
                zRotationAngle = M_PI*0.75;
                break;
            case 7:
                positionX = 469;
                positionY = 32;
                zRotationAngle = M_PI*0.75;
                break;
            default:
                break;
        }
        SKSpriteNode *smallAngularEdge = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(sizeA, sizeB)];
        smallAngularEdge.position = CGPointMake(positionX, positionY);
        smallAngularEdge.zRotation = zRotationAngle;
        smallAngularEdge.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:smallAngularEdge.size];
        smallAngularEdge.physicsBody.dynamic = NO;
        smallAngularEdge.physicsBody.categoryBitMask = ContactPhysicsBodyEdge;
        smallAngularEdge.physicsBody.collisionBitMask = ContactPhysicsBodyBall;
        smallAngularEdge.physicsBody.contactTestBitMask = ContactPhysicsBodyBall;
        smallAngularEdge.physicsBody.restitution = 0.5;
        [self addChild:smallAngularEdge];
    }
    
    for (int i = 0; i < 4; i++) {
        float sizeA = 0.0;
        float sizeB = 0.0;
        float positionX = 0.0;
        float positionY = 0.0;
        switch (i) {
            case 0:
                sizeA = 250;
                sizeB = 1;
                positionX = 259;
                positionY = 276;
                break;
            case 1:
                sizeA = 250;
                sizeB = 1;
                positionX = 259;
                positionY = 20;
                break;
            case 2:
                sizeA = 1;
                sizeB = 265;
                positionX = 26;
                positionY = 148;
                break;
            case 3:
                sizeA = 1;
                sizeB = 265;
                positionX = 492;
                positionY = 148;
                break;
            default:
                break;
        }
        SKSpriteNode *pocketsEdge = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(sizeA, sizeB)];
        pocketsEdge.position = CGPointMake(positionX, positionY);
        pocketsEdge.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pocketsEdge.size];
        pocketsEdge.physicsBody.dynamic = NO;
        pocketsEdge.physicsBody.categoryBitMask = ContactPhysicsBodyPocket;
        pocketsEdge.physicsBody.collisionBitMask = ContactPhysicsBodyBall;
        pocketsEdge.physicsBody.contactTestBitMask = ContactPhysicsBodyBall;
        [self addChild:pocketsEdge];
    }
}

-(void)setupBalls {
    SKTexture *ballColor;
    NSString *color;
    int col = 5;
    int colCnt = 0;
    int startX = self.size.width - 150;
    int startY = self.size.height/2 - 12 + ball_Radius*4;
    float newX;
    float newY;
    for (int i = 0; i < 15; i++) {
        if (i == 10) {
            ballColor = [self.textureManager blackBall];
            color = @"blackBall";
        } else if (i % 2 == 0) {
            ballColor = [self.textureManager yellowBall];
            color = @"yellowBall";
        } else {
            ballColor = [self.textureManager redBall];
            color = @"redBall";
        }
        if (colCnt < col) {
            newY = startY - colCnt * 2 * ball_Radius;
            colCnt++;
        } else {
            startX -= ball_Radius*1.7;
            startY -= ball_Radius;
            newY = startY;
            col--;
            colCnt = 1;
        }
        newX = startX;
        SKSpriteNode *ball = [SKSpriteNode spriteNodeWithTexture:ballColor];
        ball.name = color;
        ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.width/2];
        ball.physicsBody.categoryBitMask = ContactPhysicsBodyBall;
        ball.physicsBody.collisionBitMask = ContactPhysicsBodyEdge | ContactPhysicsBodyBall;
        ball.physicsBody.contactTestBitMask = ContactPhysicsBodyPocket | ContactPhysicsBodyBall;
        ball.physicsBody.usesPreciseCollisionDetection = YES;
        ball.position = CGPointMake(newX, newY);
        ball.physicsBody.density = 5;
        ball.physicsBody.friction = 0.3;
        ball.physicsBody.restitution = 0.7;
        ball.physicsBody.linearDamping= 1;
        ball.physicsBody.angularDamping = 0.8;
        [self addChild:ball];
    }
}

-(void)setupWhiteBall {
    self.whiteBall = [SKSpriteNode spriteNodeWithTexture:[self.textureManager whiteBall]];
    self.whiteBall.name = @"whiteBall";
    self.whiteBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.whiteBall.size.width/2];
    self.whiteBall.physicsBody.categoryBitMask = ContactPhysicsBodyBall;
    self.whiteBall.physicsBody.collisionBitMask = ContactPhysicsBodyEdge | ContactPhysicsBodyBall;
    self.whiteBall.physicsBody.contactTestBitMask = ContactPhysicsBodyPocket | ContactPhysicsBodyBall;
    self.whiteBall.physicsBody.usesPreciseCollisionDetection = YES;
    self.whiteBall.position = CGPointMake(147, self.size.height/2-12);
    self.whiteBall.physicsBody.density = 5;
    self.whiteBall.physicsBody.friction = 0.3;
    self.whiteBall.physicsBody.restitution = 0.5;
    self.whiteBall.physicsBody.linearDamping= 1;
    self.whiteBall.physicsBody.angularDamping = 0.8;
    [self addChild:self.whiteBall];
}

-(void)setupPowerSlider {
    SKSpriteNode *powerSliderBody = [SKSpriteNode spriteNodeWithTexture:[self.textureManager powerSlider]];
    powerSliderBody.position = CGPointMake(535, 140);
    powerSliderBody.alpha = 0.8;
    [self addChild:powerSliderBody];
    
    SKSpriteNode *powerSliderDot = [SKSpriteNode spriteNodeWithTexture:[self.textureManager psDot]];
    powerSliderDot.position = CGPointMake(536, 223);
    powerSliderDot.name = @"powerSlider";
    powerSliderDot.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:powerSliderDot.size.width/2];
    [self addChild:powerSliderDot];
}

-(void)setupCueStick {
    self.cueStick = [SKSpriteNode spriteNodeWithTexture:[self.textureManager pockballPoll]];
    self.cueStick.position = self.whiteBall.position;
    self.cueStick.anchorPoint = CGPointMake(1, 0.5);
    self.cueStick.name = @"cueStick";
    self.cueStick.hidden = YES;
    self.cueStick.zPosition = 1;
    [self addChild:self.cueStick];
}

-(void)setupTriangle {
    UIBezierPath *TrianglePath = [UIBezierPath bezierPath];
    [TrianglePath moveToPoint:CGPointMake(0, 0)];
    [TrianglePath addLineToPoint:CGPointMake(100, -58)];
    [TrianglePath addLineToPoint:CGPointMake(100, 58)];
    [TrianglePath addLineToPoint:CGPointMake(0, 0)];
    
    SKShapeNode *Triangle = [SKShapeNode shapeNodeWithPath:TrianglePath.CGPath centered:YES];
    Triangle.position = CGPointMake(378, 148);
    Triangle.lineWidth = 3;
    Triangle.strokeColor = [SKColor blackColor];
    Triangle.name = @"Triangle";
    [self addChild:Triangle];
    
    SKAction *delayAction = [SKAction waitForDuration:1.0];
    SKAction *fadeAction = [SKAction fadeOutWithDuration:0.3];
    SKAction *sequence = [SKAction sequence:@[delayAction, fadeAction]];
    [Triangle runAction: sequence completion:^{
        [Triangle removeFromParent];
    }];
}

-(void)setupGunSight {
    self.gunSight = [SKSpriteNode spriteNodeWithTexture:[self.textureManager gunsight]];
    self.gunSight.hidden = YES;
    [self addChild:self.gunSight];
}

-(void)drawLine:(CGPoint)point toPoint:(CGPoint)targetPoint {
    [[self childNodeWithName:@"line"] removeFromParent];
    SKShapeNode *line = [[SKShapeNode alloc] init];
    line.name = @"line";
    
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathMoveToPoint(myPath, NULL, point.x,point.y);
    CGPathAddLineToPoint(myPath, NULL,targetPoint.x,targetPoint.y);
    line.path = myPath;
    
    line.lineWidth = 1.0;
    line.fillColor = [SKColor blueColor];
    line.strokeColor = [SKColor whiteColor];
    line.glowWidth = 0.5;
    
    [self addChild:line];
    CGPathRelease(myPath);
}

-(void)setupShotOfPowerLabel {
    NSString *shotPowerString = [NSString stringWithFormat:@"%@%%",self.powerSliderValue];
    self.shotPowerLabel = [SKLabelNode labelNodeWithText:shotPowerString];
    self.shotPowerLabel.fontName = @"SnellRoundhand-Black";
    self.shotPowerLabel.fontColor = [SKColor whiteColor];
    self.shotPowerLabel.position = CGPointMake(536, 250);
    self.shotPowerLabel.fontSize = 20;
    [self addChild:self.shotPowerLabel];
}

-(void)setupMenuAndScore {
    SKLabelNode *menuLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(@"Pause", nil)];
    menuLabel.fontName = @"SnellRoundhand-Black";
    menuLabel.fontColor = [SKColor greenColor];
    menuLabel.position = CGPointMake(50, 295);
    menuLabel.fontSize = 20;
    [self addChild:menuLabel];
    
    SKShapeNode *pauseButton = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, 70, 25)];
    pauseButton.position = CGPointMake(15, 290);
    pauseButton.name = @"PauseButton";
    pauseButton.lineWidth = 1;
    pauseButton.strokeColor = [SKColor whiteColor];
    pauseButton.fillColor = [SKColor whiteColor];
    pauseButton.alpha = 0.2;
    [self addChild:pauseButton];
    [self setupPlayerNameAndScore];
}

-(void)setupPlayerNameAndScore {
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(@"Score:",nil)];
    scoreLabel.fontName = @"SnellRoundhand-Black";
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.position = CGPointMake(400, 295);
    scoreLabel.fontSize = 20;
    [self addChild:scoreLabel];
    self.scoreLabel = scoreLabel;
    
    SKLabelNode *currentPlayerNameLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(@"Player 1",nil)];
    currentPlayerNameLabel.fontName = @"SnellRoundhand-Black";
    currentPlayerNameLabel.fontColor = [SKColor whiteColor];
    currentPlayerNameLabel.position = CGPointMake(250, 295);
    currentPlayerNameLabel.fontSize = 20;
    [self addChild:currentPlayerNameLabel];
}

@end
