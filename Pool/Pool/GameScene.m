//
//  GameScene.m
//  Pool
//
//  Created by Billy on 06.03.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import "GameScene.h"

static const uint32_t tableEdgeCategory = 0x1 << 0;
static const uint32_t ballCategory = 0x1 << 1;
static const uint32_t pocketCategory = 0x1 << 2;

#define TEXTUREATLAS [SKTextureAtlas atlasNamed:@"images"]
#define BALL_RADIUS 10.0f
#define TouchRange 70

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
@property (nonatomic, strong) SKLabelNode *scoreLabel;
@property (nonatomic, strong) NSNumber *scoreValue;

@property (nonatomic, strong) SKLabelNode *foulLabel;
@property (nonatomic, strong) SKLabelNode *popupScoreLabel;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL canShoot;
@end

@implementation GameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        [self initContentView];
    
    }
    return self;
}

-(void)initContentView{
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    SKSpriteNode *fonParket = [SKSpriteNode spriteNodeWithTexture:[TEXTUREATLAS textureNamed:@"fon_parket"]];
    fonParket.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:fonParket];
    SKSpriteNode *bgTable = [SKSpriteNode spriteNodeWithTexture:[TEXTUREATLAS textureNamed:@"pocketBall_table"]];
    bgTable.position = CGPointMake(self.size.width/2-25, self.size.height/2-12);
    
    self.powerSliderValue = [NSNumber numberWithInt:100];
    self.scoreValue = [NSNumber numberWithInt:0];
    
    [self addChild:bgTable];
    [self setupTablePhysicsEdge];
    [self setupBalls];
    [self setupWhiteBall];
    [self setupPowerSlider];
    [self setupMenuAndScore];
    [self setupShotOfPowerLabel];
    [self setupScoreOfPlayer];
    [self setupCueStick];
    [self setupGunSight];

}


-(void)setupMenuAndScore{
    
    SKShapeNode *menuButton = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, 140, 25)];
    menuButton.position = CGPointMake(50, 290);
    menuButton.lineWidth = 1;
    menuButton.strokeColor = [SKColor blackColor];
    menuButton.fillColor = [SKColor blackColor];
    menuButton.alpha = 0.2;
    [self addChild:menuButton];
    
    SKLabelNode *menuLabel = [SKLabelNode labelNodeWithText:@"Back to menu"];
    menuLabel.fontName = @"SnellRoundhand-Black";
    menuLabel.fontColor = [SKColor blackColor];
    menuLabel.position = CGPointMake(120, 295);
    menuLabel.fontSize = 20;
    [self addChild:menuLabel];
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithText:@"Player score:"];
    scoreLabel.fontName = @"SnellRoundhand-Black";
    scoreLabel.fontColor = [SKColor blackColor];
    scoreLabel.position = CGPointMake(400, 295);
    scoreLabel.fontSize = 20;
    [self addChild:scoreLabel];
}

-(void)setupScoreOfPlayer{
    NSNumber *scoreNumber = self.scoreValue;
    NSString *scoreString = [NSString stringWithFormat:@"%@",[scoreNumber stringValue]];
    self.scoreLabel = [SKLabelNode labelNodeWithText:scoreString];
    self.scoreLabel.fontName = @"SnellRoundhand-Black";
    self.scoreLabel.fontColor = [SKColor blackColor];
    self.scoreLabel.position = CGPointMake(480, 293);
    self.scoreLabel.fontSize = 20;
    [self addChild:self.scoreLabel];
    
}

#pragma mark TABLE PHYSICS EDGES AND POCKETS

-(void)setupTablePhysicsEdge
{
    //Setup edges of the table

    for (int i = 0; i < 6; i++) {
        
        float sizeA = 0.0;
        float sizeB = 0.0;
        float positionX = 0.0;
        float positionY = 0.0;
        
        if (i == 0) { sizeA = 1; sizeB = 188; positionX = 36;  positionY = 148;}        //Left table edge
        if (i == 1) { sizeA = 193; sizeB = 1; positionX = 149; positionY = 260;}        //Top left table edge
        if (i == 2) { sizeA = 193; sizeB = 1; positionX = 369; positionY = 260;}        //Top right table edge
        if (i == 3) { sizeA = 1; sizeB = 188; positionX = 482; positionY = 148;}        //Right table edge
        if (i == 4) { sizeA = 193; sizeB = 1; positionX = 149; positionY = 36; }        //Bottom left table edge
        if (i == 5) { sizeA = 193; sizeB = 1; positionX = 369; positionY = 36; }        //Bottom right table edge

        SKSpriteNode * insideEdge = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(sizeA, sizeB)];
        insideEdge.position = CGPointMake(positionX, positionY);
        insideEdge.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:insideEdge.size];
        insideEdge.physicsBody.dynamic = NO;
        insideEdge.physicsBody.categoryBitMask = tableEdgeCategory;
        insideEdge.physicsBody.collisionBitMask = ballCategory;
        insideEdge.physicsBody.contactTestBitMask = ballCategory;
        insideEdge.physicsBody.restitution = 0.5;
        [self addChild:insideEdge];
    }
    
    //Setup small angular edges of the table
    
    for (int i = 0; i < 8; i++) {

        float positionX = 0.0;
        float positionY = 0.0;
        float zRotationAngle = 0.0;
        
        if (i == 0) { positionX = 49; positionY = 264; zRotationAngle = M_PI*0.75;}     //Left top small edge1
        if (i == 1) { positionX = 31; positionY = 247; zRotationAngle = M_PI*0.75;}     //Left top small edge2
        if (i == 2) { positionX = 31; positionY = 50;  zRotationAngle = M_PI_4;}        //Left bottom small edge1
        if (i == 3) { positionX = 49; positionY = 32;  zRotationAngle = M_PI_4;}        //Left bottom small edge2
        if (i == 4) { positionX = 469;positionY = 264; zRotationAngle = M_PI_4;}        //Right top small edge1
        if (i == 5) { positionX = 487;positionY = 247; zRotationAngle = M_PI_4;}        //Right top small edge2
        if (i == 6) { positionX = 487;positionY = 50;  zRotationAngle = M_PI*0.75;}     //Right bottom small edge1
        if (i == 7) { positionX = 469;positionY = 32;  zRotationAngle = M_PI*0.75;}     //Right bottom small edge2
        
        SKSpriteNode * smallAngularEdge = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(12, 1)];
        smallAngularEdge.position = CGPointMake(positionX, positionY);
        smallAngularEdge.zRotation = zRotationAngle;
        smallAngularEdge.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:smallAngularEdge.size];
        smallAngularEdge.physicsBody.dynamic = NO;
        smallAngularEdge.physicsBody.categoryBitMask = tableEdgeCategory;
        smallAngularEdge.physicsBody.collisionBitMask = ballCategory;
        smallAngularEdge.physicsBody.contactTestBitMask = ballCategory;
        smallAngularEdge.physicsBody.restitution = 0.5;
        [self addChild:smallAngularEdge];
    }
    
    //Setup pockets of the table

    for (int i = 0; i < 4; i++) {
        
        float sizeA = 0.0;
        float sizeB = 0.0;
        float positionX = 0.0;
        float positionY = 0.0;
        
        if (i == 0) { sizeA = 250/*468*/; sizeB = 1; positionX = 259; positionY = 276; }  //Top pocket edge
        if (i == 1) { sizeA = 250/*468*/; sizeB = 1; positionX = 259; positionY = 20;  }  //Bottom pocket edge
        if (i == 2) { sizeA = 1; sizeB = 255; positionX = 25;  positionY = 148; }         //Left pocket edge
        if (i == 3) { sizeA = 1; sizeB = 255; positionX = 493; positionY = 148; }         //Right pocket edge
    
        SKSpriteNode * pocketsEdge = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(sizeA, sizeB)];
        pocketsEdge.position = CGPointMake(positionX, positionY);
        pocketsEdge.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pocketsEdge.size];
        pocketsEdge.physicsBody.dynamic = NO;
        pocketsEdge.physicsBody.categoryBitMask = pocketCategory;
        pocketsEdge.physicsBody.collisionBitMask = ballCategory;
        pocketsEdge.physicsBody.contactTestBitMask = ballCategory;
        [self addChild:pocketsEdge];
    
    }
}

#pragma mark SETUP BALLS & CUESTICK & GUNSIGHT

-(void)setupBalls
{
    NSString * color;
    int col = 5;
    int colCnt = 0;
    int startX = self.size.width - 150;
    int startY = self.size.height/2 - 12 + BALL_RADIUS*4;
    float newX;
    float newY;
    for (int i = 0; i < 15; i++) {
        if (i == 10) {
            color = @"blackBall";
        } else if (i % 2 == 0) {
            color = @"yellowBall";
        } else {
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
        SKSpriteNode * ball = [SKSpriteNode spriteNodeWithTexture:[TEXTUREATLAS textureNamed:color]];
        ball.name = color;
        ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.width/2];
        ball.physicsBody.categoryBitMask = ballCategory;
        ball.physicsBody.collisionBitMask = tableEdgeCategory | ballCategory;
        ball.physicsBody.contactTestBitMask = pocketCategory | ballCategory;
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

-(void)setupWhiteBall
{
    self.whiteBall = [SKSpriteNode spriteNodeWithTexture:[TEXTUREATLAS textureNamed:@"whiteBall"]];
    self.whiteBall.name = @"whiteBall";
    self.whiteBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.whiteBall.size.width/2];
    self.whiteBall.physicsBody.categoryBitMask = ballCategory;
    self.whiteBall.physicsBody.collisionBitMask = tableEdgeCategory | ballCategory;
    self.whiteBall.physicsBody.contactTestBitMask = pocketCategory | ballCategory;
    self.whiteBall.physicsBody.usesPreciseCollisionDetection = YES;
    self.whiteBall.position = CGPointMake(147, self.size.height/2-12);
    self.whiteBall.physicsBody.density = 5;
    self.whiteBall.physicsBody.friction = 0.3;
    self.whiteBall.physicsBody.restitution = 0.5;
    self.whiteBall.physicsBody.linearDamping= 1;
    self.whiteBall.physicsBody.angularDamping = 0.8;
    [self addChild:self.whiteBall];
}

-(void)setupCueStick
{
    self.cueStick = [SKSpriteNode spriteNodeWithTexture:[TEXTUREATLAS textureNamed:@"pockball_poll"]];
    self.cueStick.position = self.whiteBall.position;
    self.cueStick.anchorPoint = CGPointMake(1, 0.5);
    self.cueStick.name = @"cueStick";
    self.cueStick.hidden = YES;
    self.cueStick.zPosition = 1;
    [self addChild:self.cueStick];
}

-(void)setupGunSight
{
    self.gunSight = [SKSpriteNode spriteNodeWithTexture:[TEXTUREATLAS textureNamed:@"gunsight"]];
    self.gunSight.hidden = YES;
    [self addChild:self.gunSight];
}

-(void)drawLine:(CGPoint)point toPoint:(CGPoint)targetPoint
{
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

#pragma mark SETUP POWERSLIDER

-(void)setupPowerSlider
{
    SKSpriteNode *powerSliderBody = [SKSpriteNode spriteNodeWithTexture:[TEXTUREATLAS textureNamed:@"power_slider"]];
    powerSliderBody.position = CGPointMake(535, 140);
    powerSliderBody.alpha = 0.8;
    [self addChild:powerSliderBody];
    
    SKSpriteNode *powerSliderDot = [SKSpriteNode spriteNodeWithTexture:[TEXTUREATLAS textureNamed:@"ps_dot"]];
    powerSliderDot.position = CGPointMake(536, 223);
    powerSliderDot.name = @"powerSlider";
    [self addChild:powerSliderDot];
}

-(void)setupShotOfPowerLabel{
    NSNumber *shotPowerNumber = self.powerSliderValue;
    NSString *shotPowerString = [NSString stringWithFormat:@"%@%%",[shotPowerNumber stringValue]];
    self.shotPowerLabel = [SKLabelNode labelNodeWithText:shotPowerString];
    self.shotPowerLabel.fontName = @"SnellRoundhand-Black";
    self.shotPowerLabel.fontColor = [SKColor blackColor];
    self.shotPowerLabel.position = CGPointMake(536, 250);
    self.shotPowerLabel.fontSize = 20;
    [self addChild:self.shotPowerLabel];
    
}

#pragma mark HANDLING TOUCHES

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.canShoot) {
        return;
    }
    
    for (UITouch *touch in touches) {
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

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.canShoot) {
        return;
    }
    
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
if ((location.x > 515)&&(location.x < 555)) {
    SKSpriteNode *powerSliderDot = (SKSpriteNode*)[self childNodeWithName:@"powerSlider"];
    int powerSliderDotPositionY = location.y;
    powerSliderDotPositionY = MAX(powerSliderDotPositionY, 55);
    powerSliderDotPositionY = MIN(powerSliderDotPositionY, 223);
    int powerSliderIntValue = (powerSliderDotPositionY - 53)/1.7;
    self.powerSliderValue = [NSNumber numberWithInt:powerSliderIntValue];
    powerSliderDot.position = CGPointMake(536, powerSliderDotPositionY);
    [self.shotPowerLabel removeFromParent];
    [self setupShotOfPowerLabel];}

    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if ((self.gameStatus == gameStatusShoot)&&(location.x < 510)&&(location.y < 285)){

            float touchLocationX;
            float touchLocationY;
 
            if ((location.x < 490)&&(location.x > 27)){
                touchLocationX = location.x;
            }else if (location.x <= 27){
                touchLocationX = 27;
            }else if (location.x >= 490){
                touchLocationX = 490;}
 
            if ((location.y < 268)&&(location.y > 27)){
                touchLocationY = location.y;
            }else if (location.y >= 268){
                touchLocationY = 268;
            }else if (location.y <= 27){
                touchLocationY = 27;}

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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
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
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    if ((self.gameStatus == gameStatusShoot)&&(location.x < 510)&&(location.y < 285)) {
        [[self childNodeWithName:@"line"] removeFromParent];
        self.gunSight.hidden = YES;
        self.cueStick.hidden = YES;
        int shootPower = [self.powerSliderValue intValue];
        [self.whiteBall.physicsBody applyImpulse:CGVectorMake(cos(self.cueStick.zRotation)*shootPower, sin(self.cueStick.zRotation)*shootPower)];
        [self runAction:[SKAction playSoundFileNamed:@"Shot02.wav" waitForCompletion:NO]];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (![self childNodeWithName:@"whiteBall"]) {
         [self setupWhiteBall];
    }
}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"whiteBall" usingBlock:^(SKNode *node, BOOL *stop) {
        if (fabs(node.physicsBody.velocity.dx) <= 1 && fabs(node.physicsBody.velocity.dy) <= 1) {
            self.canShoot = YES;
            self.cueStick.position = self.whiteBall.position;
            self.cueStick.hidden = NO;
        }else{
            self.canShoot = NO;
        }
    }];
}

#pragma mark HANDLING CONTACTS

- (void)didBeginContact:(SKPhysicsContact *)contact
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
    
    if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == tableEdgeCategory) {
        [self runAction:[SKAction playSoundFileNamed:@"Bank02.wav" waitForCompletion:NO]];
    }
    
    if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == ballCategory) {
        [self runAction:[SKAction playSoundFileNamed:@"Ball.wav" waitForCompletion:NO]];
    }
    
    if (firstBody.categoryBitMask == pocketCategory && secondBody.categoryBitMask == ballCategory) {
        SKSpriteNode *ball;
        if (contact.bodyA.categoryBitMask == ballCategory) {
            ball = (SKSpriteNode*)contact.bodyA.node;
        }else{
            ball = (SKSpriteNode*)contact.bodyB.node;
        }
        [self runAction:[SKAction playSoundFileNamed:@"Fall.wav" waitForCompletion:NO]];
       
        [ball removeFromParent];
   
        if ([ball.physicsBody.node.name isEqualToString:@"whiteBall"]&&![self childNodeWithName:@"foulLabel"]){
            self.foulLabel = [SKLabelNode labelNodeWithText:@"Foul!"];
            self.foulLabel.name = @"foulLabel";
            self.foulLabel.fontName = @"SnellRoundhand-Black";
            self.foulLabel.fontColor = [SKColor redColor];
            self.foulLabel.position = CGPointMake(260, 140);
            self.foulLabel.fontSize = 40;
            [self addChild:self.foulLabel];
            SKAction *actionMove = [SKAction moveTo:CGPointMake(260, 360) duration :2.5];
            [self.foulLabel runAction: actionMove];
 
//            SKView *skView = (SKView *)self.view;
//            skView.paused = YES;

        }else if(![self childNodeWithName:@"foulLabel"]/*&&![self childNodeWithName:@"scoreLabel"]*/){
            self.popupScoreLabel = [SKLabelNode labelNodeWithText:@"Score +1"];
            self.popupScoreLabel.name = @"scoreLabel";
            self.popupScoreLabel.fontName = @"SnellRoundhand-Black";
            self.popupScoreLabel.fontColor = [SKColor colorWithRed:230 green:230 blue:230 alpha:1];
            self.popupScoreLabel.position = CGPointMake(260, 140);
            self.popupScoreLabel.fontSize = 35;
            [self addChild:self.popupScoreLabel];
            SKAction *actionMove = [SKAction moveTo:CGPointMake(260, 285) duration :2.5];
            [self.self.popupScoreLabel runAction: actionMove];
            int scoreIntValue = [self.scoreValue intValue];
            self.scoreValue = [NSNumber numberWithInt:scoreIntValue + 1];
            [self.scoreLabel removeFromParent];
            [self setupScoreOfPlayer];
  
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateWithTimer:) userInfo:nil repeats:NO];
        
        //        SKEffectNode *ballEffect = [[SKEffectNode alloc]init];
        //        SKSpriteNode *ball1 = [SKSpriteNode spriteNodeWithTexture:[TEXTUREATLAS textureNamed:@"redBall"]];
        //        ball1.position = CGPointMake(278, 160);
        //        ballEffect.filter = [self blurFilter];
        //        ballEffect.blendMode = SKBlendModeAdd;
        //        ballEffect.shouldEnableEffects = YES;
        //        [ballEffect addChild:ball1];
        //        [self addChild:ballEffect];
        
    }
}

-(void)updateWithTimer:(NSTimer*)timer{
    [self.foulLabel removeFromParent];
    [self.popupScoreLabel removeFromParent];
//    SKView * skView = (SKView *)self.view;
//    skView.paused = NO;
    [self.timer invalidate];
    self.timer = nil;
}

//-(CIFilter *)blurFilter{
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [filter setDefaults];
//    [filter setValue:[NSNumber numberWithFloat:10] forKey:@"inputRadius"];
//    return filter;
//}

@end
