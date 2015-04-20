//
//  SettingsMenu.m
//  Pool
//
//  Created by Billy on 20.04.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import "SettingsMenu.h"

@interface SettingsMenu()

@property (nonatomic, weak) TextureManager *textureManager;
@property (nonatomic, assign) BOOL fingerOnSoundButton;
@property (nonatomic, assign) BOOL fingerOnBackToMenuButton;
@property (nonatomic, strong) SKLabelNode *backToMenuLabel;
@property (nonatomic, strong) SKShapeNode *backToMenuButton;
@property (nonatomic, strong) SKLabelNode *soundLabel;
@property (nonatomic, strong) SKShapeNode *soundButton;
@property (nonatomic, weak) SettingsManager *settingsManager;
@property (nonatomic, strong) NSString *soundLabelText;

@end

@implementation SettingsMenu

-(void)didMoveToView:(SKView *)view {
    self.textureManager = [TextureManager sharedManager];
    self.settingsManager = [SettingsManager sharedManager];
    [self createSceneContents];
    [self setupButtons];
}

-(void)createSceneContents {
    self.scaleMode = SKSceneScaleModeAspectFill;
    SKSpriteNode *menuBg = [SKSpriteNode spriteNodeWithTexture:[self.textureManager menuBg]];
    menuBg.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:menuBg];
}

-(void)setupButtons {

    self.soundButton = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, 180, 35)];
    self.soundButton.position = CGPointMake(self.size.width/2 - 90, 90);
    self.soundButton.name = @"SoundButton";
    self.soundButton.lineWidth = 1;
    self.soundButton.strokeColor = [SKColor whiteColor];
    self.soundButton.fillColor = [SKColor blackColor];
    self.soundButton.alpha = 0.5;
    [self addChild:self.soundButton];
    
    if ([self.settingsManager.soundState  isEqual: @"YES"]) {
        self.soundLabelText = @"Sound On";
    }else {
        self.soundLabelText = @"Sound Off";
    }
    self.soundLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(self.soundLabelText, nil)];
    self.soundLabel.fontName = @"SnellRoundhand-Black";
    self.soundLabel.name = @"SoundLabel";
    self.soundLabel.fontColor = [SKColor whiteColor];
    self.soundLabel.position = CGPointMake(self.size.width/2, 100);
    self.soundLabel.fontSize = 25;
    [self addChild:self.soundLabel];
    
    self.backToMenuButton = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, 180, 35)];
    self.backToMenuButton.position = CGPointMake(self.size.width/2 - 90, 25);
    self.backToMenuButton.name = @"BackToMenuButton";
    self.backToMenuButton.lineWidth = 1;
    self.backToMenuButton.strokeColor = [SKColor whiteColor];
    self.backToMenuButton.fillColor = [SKColor blackColor];
    self.backToMenuButton.alpha = 0.5;
    [self addChild:self.backToMenuButton];
    
    self.backToMenuLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(@"Back to menu", nil)];
    self.backToMenuLabel.fontName = @"SnellRoundhand-Black";
    self.backToMenuLabel.name = @"BackToMenuLabel";
    self.backToMenuLabel.fontColor = [SKColor whiteColor];
    self.backToMenuLabel.position = CGPointMake(self.size.width/2, 35);
    self.backToMenuLabel.fontSize = 25;
    [self addChild:self.backToMenuLabel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    SKShapeNode *touchedNode = (SKShapeNode*)[self nodeAtPoint:[touch locationInNode:self]];
    if (([touchedNode.name isEqualToString:@"BackToMenuButton"])||([touchedNode.name isEqualToString:@"BackToMenuLabel"])) {
        self.fingerOnBackToMenuButton = YES;
        self.backToMenuButton.fillColor = [SKColor whiteColor];
        self.backToMenuButton.alpha = 0.2;
    }
    
    if (([touchedNode.name isEqualToString:@"SoundButton"])||([touchedNode.name isEqualToString:@"SoundLabel"])) {
        self.fingerOnSoundButton = YES;
        self.soundButton.fillColor = [SKColor whiteColor];
        self.soundButton.alpha = 0.2;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    SKNode *touchedNode = [self nodeAtPoint:[touch locationInNode:self]];
    
    if (self.fingerOnBackToMenuButton) {
        SKShapeNode *touchedNode = (SKShapeNode*)[self childNodeWithName:@"BackToMenuButton"];
        touchedNode.fillColor = [SKColor blackColor];
        touchedNode.alpha = 0.5;
    }
    if (([touchedNode.name isEqualToString:@"BackToMenuButton"])||([touchedNode.name isEqualToString:@"BackToMenuLabel"])) {
        SKTransition *doors = [SKTransition doorwayWithDuration:0.5];
        MainMenu *mainMenu = [[MainMenu alloc] initWithSize:CGSizeMake(568, 320)];
        [self.view presentScene:mainMenu transition:doors];
    }
    
    if (self.fingerOnSoundButton) {
        SKShapeNode *touchedNode = (SKShapeNode*)[self childNodeWithName:@"SoundButton"];
        touchedNode.fillColor = [SKColor blackColor];
        touchedNode.alpha = 0.5;
    }
    if (([touchedNode.name isEqualToString:@"SoundButton"])||([touchedNode.name isEqualToString:@"SoundLabel"])) {
        if ([self.settingsManager.soundState  isEqual: @"YES"]) {
            self.soundLabelText = @"Sound Off";
            self.settingsManager.soundState = @"NO";
        }else {
            self.soundLabelText = @"Sound On";
            self.settingsManager.soundState = @"YES";            
        }
        self.soundLabel.text = self.soundLabelText;
    }
}

@end
