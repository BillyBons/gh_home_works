//
//  GameScene.m
//  Pool
//
//  Created by Billy on 06.03.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import "GameScene.h"
#import "TextureManager.h"
#import "SoundManager.h"
#import "MainMenu.h"
#import "SoundManager.h"

typedef NS_OPTIONS (NSInteger, ContactPhysicsBodyes){
    ContactPhysicsBodyEdge = 1 << 0,
    ContactPhysicsBodyBall = 1 << 1,
    ContactPhysicsBodyPocket = 1 << 2,
};

const CGFloat BALL_RADIUS = 10.0f;
const CGFloat TouchRange = 70;
const NSInteger leftBoundaryPoolTableTouch = 510;
const NSInteger topBoundaryPoolTableTouch = 285;
const NSInteger touchLeftBoundryForGunSight = 27;
const NSInteger touchRightBoundryForGunSight = 490;
const NSInteger touchTopBoundryForGunSight = 27;
const NSInteger touchBottomBoundryForGunSight = 268;
const NSInteger touchleftBoundarySliderX = 515;
const NSInteger touchRightBoundarySliderX = 555;
const CGFloat convertRatioPointToSliderValue = 1.7;

bool soundEffectsState;

typedef enum GameStatus{
    gameStatusShoot = 1,
    gameStatusMoving
}GameStatus;

@interface GameScene()<SKPhysicsContactDelegate>

@property (nonatomic, assign) GameStatus gameStatus;
@property (nonatomic, strong) SKSpriteNode *whiteBall;
@property (nonatomic, strong) SKSpriteNode *cueStick;
@property (nonatomic, strong) SKSpriteNode *gunSight;
@property (nonatomic, strong) SKLabelNode *shotPowerLabel;
@property (nonatomic, strong) NSNumber *powerSliderValue;

@property (nonatomic, strong) NSNumber *scoreValue;
@property (nonatomic, strong) SKLabelNode *foulLabel;
@property (nonatomic, strong) SKLabelNode *popupScoreLabel;
@property (nonatomic, strong) SKSpriteNode *pauseBg;
@property (nonatomic, strong) SKLabelNode *popupMenuLabel;
@property (nonatomic, strong) SKLabelNode *resumeLabel;
@property (nonatomic, strong) SKLabelNode *backToMenuLabel;
@property (nonatomic, strong) SKShapeNode *resumeButton;
@property (nonatomic, strong) SKShapeNode *backToMenuButton;
@property (nonatomic, assign) BOOL canShoot;
@property (nonatomic, weak) TextureManager *textureManager;
@property (nonatomic, weak) SettingsManager *settingsManager;
@property (nonatomic, assign) BOOL fingerOnMenuButton;
@property (nonatomic, assign) BOOL fingerOnResumeButton;
@property (nonatomic, assign) BOOL fingerOnBackToMenuButton;

@property (nonatomic, strong) SKLabelNode *scoreLabel;

@end

@implementation GameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self initContentView];
    
    }
    return self;
}

-(void)initContentView {
    self.scoreValue = @0;
    self.powerSliderValue = @100;
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    self.textureManager = [TextureManager sharedManager];
    self.settingsManager = [SettingsManager sharedManager];
    if (self.settingsManager.soundEffectsState) {
        soundEffectsState = YES;
    }else soundEffectsState = NO;

    [self setupBackgrounds];
    [self setupTablePhysicsEdge];
    [self setupBalls];
    [self setupWhiteBall];
    [self setupPowerSlider];
    [self setupMenuAndScore];
    [self setupShotOfPowerLabel];
    [self updateScoreOfPlayer];
    [self setupCueStick];
    [self setupGunSight];
    [self setupTriangle];
}

- (UIImage *)getBluredScreenshot {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 1);
    [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:YES];
    UIImage *ss = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    [gaussianBlurFilter setValue:[CIImage imageWithCGImage:[ss CGImage]] forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:@3 forKey:kCIInputRadiusKey];
    
    CIImage *outputImage = [gaussianBlurFilter outputImage];
    CIContext *context   = [CIContext contextWithOptions:nil];
    CGRect rect          = [outputImage extent];
    rect.origin.x        += (rect.size.width  - ss.size.width ) / 2;
    rect.origin.y        += (rect.size.height - ss.size.height) / 2;
    rect.size            = ss.size;
    CGImageRef cgimg     = [context createCGImage:outputImage fromRect:rect];
    UIImage *image       = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    return image;
}

-(void)pause {
    self.pauseBg = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[self getBluredScreenshot]]];
    self.pauseBg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.pauseBg.alpha = 0;
    self.pauseBg.zPosition = 2;
    [self.pauseBg runAction:[SKAction fadeAlphaTo:1 duration:0.4]];
    [self addChild:self.pauseBg];
}

-(void)popupMenu {
    self.popupMenuLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(@"- Game paused -", nil)];
    self.popupMenuLabel.fontName = @"SnellRoundhand-Black";
    self.popupMenuLabel.fontColor = [SKColor redColor];
    self.popupMenuLabel.position = CGPointMake(self.size.width/2, 210);
    self.popupMenuLabel.fontSize = 25;
    self.popupMenuLabel.zPosition = 3;
    self.popupMenuLabel.alpha = 0.6;
    [self addChild:self.popupMenuLabel];

    self.resumeLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(@"Resume", nil)];
    self.resumeLabel.fontName = @"SnellRoundhand-Black";
    self.resumeLabel.fontColor = [SKColor blackColor];
    self.resumeLabel.position = CGPointMake(self.size.width/2, 170);
    self.resumeLabel.fontSize = 25;
    self.resumeLabel.zPosition = 3;
    [self addChild:self.resumeLabel];
    
    self.resumeButton = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, 180, 35)];
    self.resumeButton.position = CGPointMake(self.size.width/2 - 90, 160);
    self.resumeButton.name = @"ResumeButton";
    self.resumeButton.lineWidth = 1;
    self.resumeButton.strokeColor = [SKColor blackColor];
    self.resumeButton.fillColor = [SKColor clearColor];
    self.resumeButton.alpha = 0.5;
    self.resumeButton.zPosition = 3;
    [self addChild:self.resumeButton];
    [self popupMenuBack];
}

-(void)popupMenuBack {
    self.backToMenuLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(@"Back to menu", nil)];
    self.backToMenuLabel.fontName = @"SnellRoundhand-Black";
    self.backToMenuLabel.fontColor = [SKColor blackColor];
    self.backToMenuLabel.position = CGPointMake(self.size.width/2, 120);
    self.backToMenuLabel.fontSize = 25;
    self.backToMenuLabel.zPosition = 3;
    [self addChild:self.backToMenuLabel];
    
    self.backToMenuButton = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, 180, 35)];
    self.backToMenuButton.position = CGPointMake(self.size.width/2 - 90, 110);
    self.backToMenuButton.name = @"BackToMenuButton";
    self.backToMenuButton.lineWidth = 1;
    self.backToMenuButton.strokeColor = [SKColor blackColor];
    self.backToMenuButton.fillColor = [SKColor clearColor];
    self.backToMenuButton.alpha = 0.5;
    self.backToMenuButton.zPosition = 3;
    [self addChild:self.backToMenuButton];
}

-(void)removePopupMenu {
    [self.pauseBg removeFromParent];
    [self.popupMenuLabel removeFromParent];
    [self.resumeLabel removeFromParent];
    [self.backToMenuLabel removeFromParent];
    [self.resumeButton removeFromParent];
    [self.backToMenuButton removeFromParent];
}

#pragma mark Setup Functions

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
        SKSpriteNode * insideEdge = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(sizeA, sizeB)];
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
        SKSpriteNode * smallAngularEdge = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(12, 1)];
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
        SKSpriteNode * pocketsEdge = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(sizeA, sizeB)];
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
    int startY = self.size.height/2 - 12 + BALL_RADIUS*4;
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
            newY = startY - colCnt * 2 * BALL_RADIUS;
            colCnt++;
        } else {
            startX -= BALL_RADIUS*1.7;
            startY -= BALL_RADIUS;
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

#pragma mark Update Functions

-(void)updateScoreOfPlayer {
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %@",self.scoreValue];
}

-(void)updateShotOfPowerLabel {
    self.shotPowerLabel.text = [NSString stringWithFormat:@"%@%%",self.powerSliderValue];
}

-(void)popupFoul {
    self.foulLabel = [SKLabelNode labelNodeWithText:@"Foul!"];
    self.foulLabel.name = @"foulLabel";
    self.foulLabel.fontName = @"SnellRoundhand-Black";
    self.foulLabel.fontColor = [SKColor colorWithRed:150
                                               green:0
                                                blue:0
                                               alpha:1.0];
    self.foulLabel.position = CGPointMake(260, 140);
    self.foulLabel.fontSize = 40;
    [self addChild:self.foulLabel];
    SKAction *actionMove = [SKAction moveTo:CGPointMake(260, 240) duration:1.5];
    SKAction *fadeAction = [SKAction fadeOutWithDuration:0.75];
    SKAction *delayAction = [SKAction waitForDuration:0.75];
    SKAction *sequence = [SKAction sequence:@[delayAction, fadeAction]];
    SKAction *compoundAction = [SKAction group:@[actionMove, sequence]];
    [self.foulLabel runAction: compoundAction completion:^{
        [self.foulLabel removeFromParent];
    }];
}

-(void)popupScore {
    self.popupScoreLabel = [SKLabelNode labelNodeWithText:@"Score +1"];
    self.popupScoreLabel.name = @"scoreLabel";
    self.popupScoreLabel.fontName = @"SnellRoundhand-Black";
    self.popupScoreLabel.fontColor = [SKColor colorWithRed:230
                                                     green:230
                                                      blue:230
                                                     alpha:1.0];
    self.popupScoreLabel.position = CGPointMake(260, 140);
    self.popupScoreLabel.fontSize = 35;
    [self addChild:self.popupScoreLabel];
    SKAction *actionMove = [SKAction moveTo:CGPointMake(260, 240) duration:1.5];
    SKAction *fadeAction = [SKAction fadeOutWithDuration:0.75];
    SKAction *delayAction = [SKAction waitForDuration:0.75];
    SKAction *sequence = [SKAction sequence:@[delayAction, fadeAction]];
    SKAction *compoundAction = [SKAction group:@[actionMove, sequence]];
    [self.popupScoreLabel runAction: compoundAction completion:^{
        [self.popupScoreLabel removeFromParent];
    }];
    NSInteger scoreIntValue = [self.scoreValue intValue];
    self.scoreValue = @(scoreIntValue + 1);
    [self updateScoreOfPlayer];
}

#pragma mark Handling Touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    SKShapeNode *touchedNode = (SKShapeNode*)[self nodeAtPoint:[touch locationInNode:self]];
    if ([touchedNode.name isEqualToString:@"PauseButton"]) {
        self.fingerOnMenuButton = YES;
        touchedNode.alpha = 0.4;
    }
    
    if ([touchedNode.name isEqualToString:@"ResumeButton"]) {
        self.fingerOnResumeButton = YES;
        touchedNode.fillColor = [SKColor blackColor];
        touchedNode.alpha = 0.3;
    }

    if ([touchedNode.name isEqualToString:@"BackToMenuButton"]) {
        self.fingerOnBackToMenuButton = YES;
        touchedNode.fillColor = [SKColor blackColor];
        touchedNode.alpha = 0.3;
    }
    
    if (!self.canShoot) {
       return;
    }
    
    for (UITouch* touch in touches) {
        CGPoint location = [touch locationInNode:self];
        float diffx = location.x - self.whiteBall.position.x;
        float diffy = location.y - self.whiteBall.position.y;
        float diff = pow(diffx, 2) + pow(diffy, 2);
        if (diff < pow(BALL_RADIUS * 4, 2)) {
            self.cueStick.position = self.whiteBall.position;
            self.cueStick.zRotation = atan2(diffy,diffx) ;
            self.gameStatus = gameStatusShoot;
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.canShoot) {
        return;
    }
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:location];
    SKSpriteNode *powerSliderDot = (SKSpriteNode*)[self childNodeWithName:@"powerSlider"];
    NSInteger powerSliderDotPositionY = location.y;
    powerSliderDotPositionY = MAX(powerSliderDotPositionY, 55);
    powerSliderDotPositionY = MIN(powerSliderDotPositionY, 223);
    if ([touchedNode.name isEqualToString:@"powerSlider"]) {
        NSInteger powerSliderIntValue = (powerSliderDotPositionY - 53)/convertRatioPointToSliderValue;
        self.powerSliderValue = [NSNumber numberWithLong:powerSliderIntValue];
        powerSliderDot.position = CGPointMake(536, powerSliderDotPositionY);
        [self updateShotOfPowerLabel];
    }
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ((self.gameStatus == gameStatusShoot)&&(location.x < leftBoundaryPoolTableTouch)&&(location.y < topBoundaryPoolTableTouch)){
            float touchLocationX;
            float touchLocationY;
            if ((location.x < touchRightBoundryForGunSight)&&(location.x > touchLeftBoundryForGunSight)){
                touchLocationX = location.x;
            }else if (location.x <= touchLeftBoundryForGunSight){
                touchLocationX = touchLeftBoundryForGunSight;
            }else if (location.x >= touchRightBoundryForGunSight){
                touchLocationX = touchRightBoundryForGunSight;}
 
            if ((location.y < touchBottomBoundryForGunSight)&&(location.y > touchTopBoundryForGunSight)){
                touchLocationY = location.y;
            }else if (location.y >= touchBottomBoundryForGunSight){
                touchLocationY = touchBottomBoundryForGunSight;
            }else if (location.y <= touchTopBoundryForGunSight){
                touchLocationY = touchTopBoundryForGunSight;}

            float diffx = touchLocationX - self.whiteBall.position.x;
            float diffy = touchLocationY - self.whiteBall.position.y;
            float angle = atan2(diffy, diffx);
            float diff = pow(diffx, 2) + pow(diffy, 2);
           
            if (diff > pow(BALL_RADIUS * 2, 2)) {
                self.cueStick.zRotation = atan2(diffy,diffx);
                [self drawLine:CGPointMake(cos(angle)*BALL_RADIUS*1.5 + self.whiteBall.position.x, sin(angle)*BALL_RADIUS*1.5 + self.whiteBall.position.y) toPoint:CGPointMake(touchLocationX - cos(angle)*BALL_RADIUS*1.5,touchLocationY - sin(angle)*BALL_RADIUS*1.5)];
                self.gunSight.hidden = NO;
                self.gunSight.position = CGPointMake(touchLocationX, touchLocationY);
            }else{
                [[self childNodeWithName:@"line"] removeFromParent];
                self.gunSight.position = CGPointMake(touchLocationX, touchLocationY);
                self.cueStick.zRotation = atan2(diffy,diffx);
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch* touch = [touches anyObject];
    SKNode *touchedNode = [self nodeAtPoint:[touch locationInNode:self]];
    
    if (self.fingerOnMenuButton) {
        SKNode *touchedNode = (SKShapeNode*)[self childNodeWithName:@"PauseButton"];
        touchedNode.alpha = 0.2;
    }
    if ([touchedNode.name isEqualToString:@"PauseButton"]) {
        [self pause];
        [self popupMenu];
    }
 
    if (self.fingerOnResumeButton) {
        SKShapeNode *touchedNode = (SKShapeNode*)[self childNodeWithName:@"ResumeButton"];
        touchedNode.fillColor = [SKColor clearColor];
        touchedNode.alpha = 0.5;
    }
    if ([touchedNode.name isEqualToString:@"ResumeButton"]) {
        [self removePopupMenu];
    }
    
    if (self.fingerOnBackToMenuButton) {
        SKShapeNode *touchedNode = (SKShapeNode*)[self childNodeWithName:@"BackToMenuButton"];
        touchedNode.fillColor = [SKColor clearColor];
        touchedNode.alpha = 0.5;
    }
    if ([touchedNode.name isEqualToString:@"BackToMenuButton"]) {
        SKTransition *doors = [SKTransition doorwayWithDuration:0.5];
        MainMenu *mainMenu = [[MainMenu alloc] initWithSize:CGSizeMake(568, 320)];
        [self.view presentScene:mainMenu transition:doors];
    }
    
    if (!self.canShoot) {
        return;
    }
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        float diffx = location.x - self.whiteBall.position.x;
        float diffy = location.y - self.whiteBall.position.y;
        float diff = pow(diffx, 2) + pow(diffy, 2);
        if (diff < pow(BALL_RADIUS, 2)) {
            return;
        }
    }

    CGPoint location = [touch locationInNode:self];

    if ((self.gameStatus == gameStatusShoot)&&(location.x < leftBoundaryPoolTableTouch)&&(location.y < topBoundaryPoolTableTouch)) {
        [[self childNodeWithName:@"line"] removeFromParent];
        self.gunSight.hidden = YES;
        self.cueStick.hidden = YES;
        int shootPower = [self.powerSliderValue intValue];
        [self.whiteBall.physicsBody applyImpulse:CGVectorMake(cos(self.cueStick.zRotation)*shootPower, sin(self.cueStick.zRotation)*shootPower)];
        if ((shootPower < 33)&&(soundEffectsState)) {
            [SoundManager playSoundShot1:self];
        }else if(soundEffectsState){
            [SoundManager playSoundShot2:self];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    if (![self childNodeWithName:@"whiteBall"]) {
         [self setupWhiteBall];
    }
}

-(void)didSimulatePhysics {
    [self enumerateChildNodesWithName:@"whiteBall" usingBlock:^(SKNode *node, BOOL *stop) {
        if ((fabs(node.physicsBody.velocity.dx) <= 1 && fabs(node.physicsBody.velocity.dy) <= 1)&&(![self childNodeWithName:@"ResumeButton"])) {
            [self whiteBallStopMoving];
        }else{
            self.canShoot = NO;
        }
    }];
}

-(void)whiteBallStopMoving {
    self.canShoot = YES;
    self.cueStick.hidden = NO;
    self.cueStick.position = self.whiteBall.position;
}

#pragma mark Handling Contacts

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (firstBody.categoryBitMask == ContactPhysicsBodyBall && secondBody.categoryBitMask == ContactPhysicsBodyEdge) {
        if (soundEffectsState) {
            [SoundManager playSoundEdge:self];
        }
    }
    
    if (firstBody.categoryBitMask == ContactPhysicsBodyBall && secondBody.categoryBitMask == ContactPhysicsBodyBall) {
        if (soundEffectsState) {
            [SoundManager playSoundBall:self];
        }
    }
    
    if (firstBody.categoryBitMask == ContactPhysicsBodyPocket && secondBody.categoryBitMask == ContactPhysicsBodyBall) {
        SKSpriteNode *ball;
        self.ballFallIntoPocket = YES;
        if (contact.bodyA.categoryBitMask == ContactPhysicsBodyBall) {
            ball = (SKSpriteNode*)contact.bodyA.node;
        }else{
            ball = (SKSpriteNode*)contact.bodyB.node;
        }
        [self ballFallInPocket:ball];
    }
}

-(void)ballFallInPocket:(SKSpriteNode*)ball {
    if (soundEffectsState) {
        [SoundManager playSoundFall:self];
    }
    if ([ball.physicsBody.node.name isEqualToString:@"whiteBall"]){
        [self whiteBallFallInPocket:ball];
    }else if ([ball.physicsBody.node.name isEqualToString:@"blackBall"]) {
        [self blackBallFallInPocket:ball];
    }else if ([ball.physicsBody.node.name isEqualToString:@"yellowBall"]){
        [self yellowBallFallInPocket:ball];
    }else if ([ball.physicsBody.node.name isEqualToString:@"redBall"]) {
        [self redBallFallInPocket:ball];
    }
    ball.physicsBody.dynamic = NO;
    SKAction *scaleBall = [SKAction scaleTo:0.0 duration:0.1];
    [ball runAction:scaleBall completion: ^{
        [ball removeFromParent];
    }];
}

-(void)yellowBallFallInPocket:(SKSpriteNode*)ball {
    [self popupScore];
}

-(void)redBallFallInPocket:(SKSpriteNode*)ball {
    [self popupScore];
}

-(void)whiteBallFallInPocket:(SKSpriteNode*)ball {
    [self popupFoul];
    [ball removeFromParent];
}

-(void)blackBallFallInPocket:(SKSpriteNode*)ball {
    [self popupFoul];
    [ball removeFromParent];
}

@end
