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
@property (nonatomic, weak) SettingsManager *settingsManager;
@property (nonatomic, weak) SoundManager *soundManager;
@property (nonatomic, assign) BOOL fingerOnSoundButton;
@property (nonatomic, assign) BOOL fingerOnMusicButton;
@property (nonatomic, assign) BOOL fingerOnBackToMenuButton;
@property (nonatomic, strong) SKLabelNode *backToMenuLabel;
@property (nonatomic, strong) SKShapeNode *backToMenuButton;
@property (nonatomic, strong) SKLabelNode *soundEffectsLabel;
@property (nonatomic, strong) SKShapeNode *soundEffectsButton;
@property (nonatomic, strong) SKLabelNode *bgMusicLabel;
@property (nonatomic, strong) SKShapeNode *bgMusicButton;

@property (nonatomic, strong) NSString *soundEffectsLabelText;
@property (nonatomic, strong) NSString *bgMusicLabelText;

@end

@implementation SettingsMenu

-(void)didMoveToView:(SKView *)view {
    self.textureManager = [TextureManager sharedManager];
    self.settingsManager = [SettingsManager sharedManager];
    self.soundManager = [SoundManager sharedManager];
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
    self.soundEffectsButton = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, 180, 35)];
    self.soundEffectsButton.position = CGPointMake(self.size.width/2 - 90, 78);
    self.soundEffectsButton.name = @"SoundButton";
    self.soundEffectsButton.lineWidth = 1;
    self.soundEffectsButton.strokeColor = [SKColor whiteColor];
    self.soundEffectsButton.fillColor = [SKColor blackColor];
    self.soundEffectsButton.alpha = 0.5;
    [self addChild:self.soundEffectsButton];
    
    if (self.settingsManager.soundEffectsState) {
        self.soundEffectsLabelText = @"Sound effects On";
    }else {
        self.soundEffectsLabelText = @"Sound effects Off";
    }
    self.soundEffectsLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(self.soundEffectsLabelText, nil)];
    self.soundEffectsLabel.fontName = @"SnellRoundhand-Black";
    self.soundEffectsLabel.name = @"SoundLabel";
    self.soundEffectsLabel.fontColor = [SKColor whiteColor];
    self.soundEffectsLabel.position = CGPointMake(self.size.width/2, 88);
    self.soundEffectsLabel.fontSize = 22;
    [self addChild:self.soundEffectsLabel];
    
    self.bgMusicButton = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, 180, 35)];
    self.bgMusicButton.position = CGPointMake(self.size.width/2 - 90, 130);
    self.bgMusicButton.name = @"MusicButton";
    self.bgMusicButton.lineWidth = 1;
    self.bgMusicButton.strokeColor = [SKColor whiteColor];
    self.bgMusicButton.fillColor = [SKColor blackColor];
    self.bgMusicButton.alpha = 0.5;
    [self addChild:self.bgMusicButton];
    
    if (self.settingsManager.bgMusicState) {
        self.bgMusicLabelText = @"Music On";
    }else {
        self.bgMusicLabelText = @"Music Off";
    }
    self.bgMusicLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(self.bgMusicLabelText, nil)];
    self.bgMusicLabel.fontName = @"SnellRoundhand-Black";
    self.bgMusicLabel.name = @"MusicLabel";
    self.bgMusicLabel.fontColor = [SKColor whiteColor];
    self.bgMusicLabel.position = CGPointMake(self.size.width/2, 140);
    self.bgMusicLabel.fontSize = 22;
    [self addChild:self.bgMusicLabel];
    
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
    self.backToMenuLabel.fontSize = 22;
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
        self.soundEffectsButton.fillColor = [SKColor whiteColor];
        self.soundEffectsButton.alpha = 0.2;
    }
    
    if (([touchedNode.name isEqualToString:@"MusicButton"])||([touchedNode.name isEqualToString:@"MusicLabel"])) {
        self.fingerOnMusicButton = YES;
        self.bgMusicButton.fillColor = [SKColor whiteColor];
        self.bgMusicButton.alpha = 0.2;
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
        if (self.settingsManager.soundEffectsState) {
            self.soundEffectsLabelText = @"Sound effects Off";
            self.settingsManager.soundEffectsState = NO;
        }else {
            self.soundEffectsLabelText = @"Sound effects On";
            self.settingsManager.soundEffectsState = YES;
        }
        self.soundEffectsLabel.text = self.soundEffectsLabelText;
    }
    
    if (self.fingerOnMusicButton) {
        SKShapeNode *touchedNode = (SKShapeNode*)[self childNodeWithName:@"MusicButton"];
        touchedNode.fillColor = [SKColor blackColor];
        touchedNode.alpha = 0.5;
    }
    if (([touchedNode.name isEqualToString:@"MusicButton"])||([touchedNode.name isEqualToString:@"MusicLabel"])) {
        if (self.settingsManager.bgMusicState) {
            self.bgMusicLabelText = @"Music Off";
            self.settingsManager.bgMusicState = NO;
            [self.soundManager.bgPlayer stop];
        }else {
            self.bgMusicLabelText = @"Music On";
            self.settingsManager.bgMusicState = YES;
            [self.soundManager.bgPlayer play];
        }
        self.bgMusicLabel.text = self.bgMusicLabelText;
    }
}

@end
