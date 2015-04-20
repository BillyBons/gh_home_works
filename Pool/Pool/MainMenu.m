//
//  MainMenu.m
//  Pool
//
//  Created by Billy on 14.04.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import "MainMenu.h"

@interface MainMenu()

@property (nonatomic, weak) TextureManager *textureManager;
@property (nonatomic, assign) BOOL fingerOnPracticeMenuButton;
@property (nonatomic, assign) BOOL fingerOnTwoPlayersMenuButton;
@property (nonatomic, assign) BOOL fingerOnSettingsMenuButton;

@end

@implementation MainMenu

-(void)didMoveToView:(SKView *)view {
    self.textureManager = [TextureManager sharedManager];
    [self createSceneContents];
    [self setupPracticeMenuButton];
    [self setupTwoPlayersMenuButton];
    [self setupSettingsMenuButton];
}

#pragma mark Setup Scene Contents

-(void)createSceneContents {
    self.scaleMode = SKSceneScaleModeAspectFill;
    SKSpriteNode *menuBg = [SKSpriteNode spriteNodeWithTexture:[self.textureManager menuBg]];
    menuBg.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:menuBg];
}

-(void)setupPracticeMenuButton {
    SKSpriteNode *menuPracticeButton = [SKSpriteNode spriteNodeWithTexture:[self.textureManager practiceButtonPassive]];
    menuPracticeButton.name = @"Practice";
    menuPracticeButton.position = CGPointMake(self.size.width/2, 150);
    [self addChild:menuPracticeButton];
}

-(void)setupTwoPlayersMenuButton {
    SKSpriteNode *twoPlayersMenuButton = [SKSpriteNode spriteNodeWithTexture:[self.textureManager twoPlayersButtonPassive]];
    twoPlayersMenuButton.name = @"TwoPlayers";
    twoPlayersMenuButton.position = CGPointMake(self.size.width/2, 98);
    [self addChild:twoPlayersMenuButton];
}

-(void)setupSettingsMenuButton {
    SKSpriteNode *settingsMenuButton = [SKSpriteNode spriteNodeWithTexture:[self.textureManager settingsButtonPassive]];
    settingsMenuButton.name = @"Settings";
    settingsMenuButton.position = CGPointMake(self.size.width/2, 46);
    [self addChild:settingsMenuButton];
}

#pragma mark Handling touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    SKNode *touchedNode = [self nodeAtPoint:[touch locationInNode:self]];
    if ([touchedNode.name isEqualToString:@"Practice"]) {
        self.fingerOnPracticeMenuButton = YES;
        SKAction *changeButtonState = [SKAction setTexture:[self.textureManager practiceButtonActive]];
        [touchedNode runAction:changeButtonState];
    }
    if ([touchedNode.name isEqualToString:@"TwoPlayers"]) {
        self.fingerOnTwoPlayersMenuButton = YES;
        SKAction *changeButtonState = [SKAction setTexture:[self.textureManager twoPlayersButtonActive]];
        [touchedNode runAction:changeButtonState];
    }
    if ([touchedNode.name isEqualToString:@"Settings"]) {
        self.fingerOnSettingsMenuButton = YES;
        SKAction *changeButtonState = [SKAction setTexture:[self.textureManager settingsButtonActive]];
        [touchedNode runAction:changeButtonState];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    SKNode *touchedNode = [self nodeAtPoint:[touch locationInNode:self]];
    
    if (self.fingerOnPracticeMenuButton) {
        SKNode *touchedNode = (SKShapeNode*)[self childNodeWithName:@"Practice"];
        SKAction *changeButtonState = [SKAction setTexture:[self.textureManager practiceButtonPassive]];
        [touchedNode runAction:changeButtonState];
    }
    if ([touchedNode.name isEqualToString:@"Practice"]) {
        SKTransition *doors = [SKTransition doorwayWithDuration:0.5];
        GameScene *gameScene = [[GameScene alloc] initWithSize:CGSizeMake(568, 320)];
        [self.view presentScene:gameScene transition:doors];
    }
    
    if (self.fingerOnTwoPlayersMenuButton) {
        SKNode *touchedNode = (SKShapeNode*)[self childNodeWithName:@"TwoPlayers"];
        SKAction *changeButtonState = [SKAction setTexture:[self.textureManager twoPlayersButtonPassive]];
        [touchedNode runAction:changeButtonState];
    }
    
    if (self.fingerOnSettingsMenuButton) {
        SKNode *touchedNode = (SKShapeNode*)[self childNodeWithName:@"Settings"];
        SKAction *changeButtonState = [SKAction setTexture:[self.textureManager settingsButtonPassive]];
        [touchedNode runAction:changeButtonState];
    }
    if ([touchedNode.name isEqualToString:@"Settings"]) {
        SKTransition *doors = [SKTransition doorwayWithDuration:0.5];
        SettingsMenu *settingsMenu = [[SettingsMenu alloc] initWithSize:CGSizeMake(568, 320)];
        [self.view presentScene:settingsMenu transition:doors];
    }
}
@end
