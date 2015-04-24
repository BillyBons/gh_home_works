//
//  MultiPlayerGameScene.m
//  Pool
//
//  Created by Billy on 22.04.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import "MultiPlayerGameScene.h"
#import "Player.h"

@interface MultiPlayerGameScene()

@property (nonatomic, strong) Player *currentPlayer;
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) SKLabelNode *player1Label;
@property (nonatomic, strong) SKLabelNode *player2Label;
@property (nonatomic, strong) SKLabelNode *score1Label;
@property (nonatomic, strong) SKLabelNode *score2Label;
@property (nonatomic, strong) NSString *player1Color;
@property (nonatomic, strong) NSString *player2Color;
@property (nonatomic, strong) NSNumber *player1Score;
@property (nonatomic, strong) NSNumber *player2Score;
@property BOOL ballIntoPocket;

@end

@implementation MultiPlayerGameScene

-(id)initWithPlayers:(NSMutableArray*)players {
    self = [super initWithSize:CGSizeMake(568, 320)];
    super.ballFallIntoPocket = YES;
    self.ballIntoPocket = YES;
    self.player1Score = @0;
    self.player2Score = @0;
    self.players = players;
    self.currentPlayer = [players firstObject];
    [self playerSelectPopup];
    [self visualisationCurrentPlayer];
    return self;
}

-(void)visualisationCurrentPlayer {
    if ([self.currentPlayer.name isEqualToString:@"Player 1"]) {
        self.player2Label.alpha = 0.5;
        self.score2Label.alpha = 0.5;
        self.player1Label.alpha = 1.0;
        self.score1Label.alpha = 1.0;
    }else if ([self.currentPlayer.name isEqualToString:@"Player 2"]) {
        self.player1Label.alpha = 0.5;
        self.score1Label.alpha = 0.5;
        self.player2Label.alpha = 1.0;
        self.score2Label.alpha = 1.0;
    }
}

-(void)setupPlayerNameAndScore {
    SKLabelNode *player1NameLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(@"Player 1",nil)];
    player1NameLabel.fontName = @"SnellRoundhand-Black";
    player1NameLabel.fontColor = [SKColor whiteColor];
    player1NameLabel.position = CGPointMake(150, 295);
    player1NameLabel.fontSize = 20;
    [self addChild:player1NameLabel];
    self.player1Label = player1NameLabel;
    
    SKLabelNode *scoreLabelPlayer1 = [SKLabelNode labelNodeWithText:NSLocalizedString(@"score: 0",nil)];
    scoreLabelPlayer1.fontName = @"SnellRoundhand-Black";
    scoreLabelPlayer1.fontColor = [SKColor whiteColor];
    scoreLabelPlayer1.position = CGPointMake(230, 295);
    scoreLabelPlayer1.fontSize = 20;
    [self addChild:scoreLabelPlayer1];
    self.score1Label = scoreLabelPlayer1;
    
    SKLabelNode *player2NameLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(@"Player 2",nil)];
    player2NameLabel.fontName = @"SnellRoundhand-Black";
    player2NameLabel.fontColor = [SKColor whiteColor];
    player2NameLabel.position = CGPointMake(370, 295);
    player2NameLabel.fontSize = 20;
    [self addChild:player2NameLabel];
    self.player2Label = player2NameLabel;
    
    SKLabelNode *scoreLabelPlayer2 = [SKLabelNode labelNodeWithText:NSLocalizedString(@"score: 0",nil)];
    scoreLabelPlayer2.fontName = @"SnellRoundhand-Black";
    scoreLabelPlayer2.fontColor = [SKColor whiteColor];
    scoreLabelPlayer2.position = CGPointMake(450, 295);
    scoreLabelPlayer2.fontSize = 20;
    [self addChild:scoreLabelPlayer2];
    self.score2Label = scoreLabelPlayer2;
}

-(void)setCurrentPlayer:(Player *)currentPlayer {
    _currentPlayer = currentPlayer;
    [self updateScoreOfPlayer];
}

-(void)updateScoreOfPlayer {
    if ([self.currentPlayer.name isEqualToString:@"Player 1"]) {
        self.score1Label.text = [NSString stringWithFormat:@"score: %@",self.player1Score];
    }else if ([self.currentPlayer.name isEqualToString:@"Player 2"]) {
        self.score2Label.text = [NSString stringWithFormat:@"score: %@",self.player2Score];
    }
}

//-(void)whiteBallStopped {
//    [super whiteBallStopped];
//    if ((!super.ballFallIntoPocket)&&(self.ballIntoPocket)) {
//        [self selectNextPlayer];
//        self.ballFallIntoPocket = NO;
//    }
//}

-(void)whiteBallFallInPocket:(SKSpriteNode*)ball {
    [super whiteBallFallInPocket:ball];
    [self selectNextPlayer];
}

-(void)blackBallFallInPocket:(SKSpriteNode*)ball {
    if (([self.player1Score intValue] == 1)||([self.player2Score intValue] == 1)) {
        [ball removeFromParent];
        [super pause];
        [super popupMenuBack];
        [self playerWinLabel];
    } else {
    [ball removeFromParent];
    [super pause];
    [super popupMenuBack];
    [self playerLooseLabel];
    }
}

-(void)yellowBallFallInPocket:(SKSpriteNode*)ball {
    if (([self.currentPlayer.name isEqualToString:@"Player 1"])&&(!self.player1Color)) {
        self.player1Label.fontColor = [SKColor yellowColor];
        self.player2Label.fontColor = [SKColor redColor];
        self.player1Color = @"yellow";
        self.player2Color = @"red";
        self.currentPlayer.color = self.player1Color;
    }else if (([self.currentPlayer.name isEqualToString:@"Player 2"])&&(!self.player2Color)) {
        self.player2Label.fontColor = [SKColor yellowColor];
        self.player1Label.fontColor = [SKColor redColor];
        self.player2Color = @"yellow";
        self.player1Color = @"red";
        self.currentPlayer.color = self.player2Color;
    }
    if ([self.currentPlayer.color isEqualToString:@"yellow"]) {
        [super yellowBallFallInPocket:ball];
        [ball removeFromParent];
        if ([self.currentPlayer.name isEqualToString:@"Player 1"]){
            NSInteger scoreIntValue = [self.player1Score intValue];
            self.player1Score = @(scoreIntValue +1);
            [self updateScoreOfPlayer];
        } else if ([self.currentPlayer.name isEqualToString:@"Player 2"]) {
            NSInteger scoreIntValue = [self.player2Score intValue];
            self.player2Score = @(scoreIntValue +1);
            [self updateScoreOfPlayer];
        }
    }else {
        if ([self.currentPlayer.name isEqualToString:@"Player 1"]) {
            NSInteger scoreIntValue = [self.player2Score intValue];
            self.player2Score = @(scoreIntValue +1);
            [self updateScoreOfPlayer];
        }
        if ([self.currentPlayer.name isEqualToString:@"Player 2"]) {
            NSInteger scoreIntValue = [self.player1Score intValue];
            self.player1Score = @(scoreIntValue +1);
            [self updateScoreOfPlayer];
        }
        [self selectNextPlayer];
    }
}

-(void)redBallFallInPocket:(SKSpriteNode*)ball {
    if (([self.currentPlayer.name isEqualToString:@"Player 1"])&&(!self.player1Color)) {
        self.player1Label.fontColor = [SKColor redColor];
        self.player2Label.fontColor = [SKColor yellowColor];
        self.player1Color = @"red";
        self.player2Color = @"yellow";
        self.currentPlayer.color = self.player1Color;
    }else if (([self.currentPlayer.name isEqualToString:@"Player 2"])&&(!self.player2Color)) {
        self.player2Label.fontColor = [SKColor redColor];
        self.player1Label.fontColor = [SKColor yellowColor];
        self.player2Color = @"red";
        self.player1Color = @"yellow";
        self.currentPlayer.color = self.player2Color;
    }
    if ([self.currentPlayer.color isEqualToString:@"red"]) {
        [super redBallFallInPocket:ball];
        [ball removeFromParent];
        if ([self.currentPlayer.name isEqualToString:@"Player 1"]){
            NSInteger scoreIntValue = [self.player1Score intValue];
            self.player1Score = @(scoreIntValue +1);
            [self updateScoreOfPlayer];
        } else if ([self.currentPlayer.name isEqualToString:@"Player 2"]) {
            NSInteger scoreIntValue = [self.player2Score intValue];
            self.player2Score = @(scoreIntValue +1);
            [self updateScoreOfPlayer];
        }
    }else {
        if ([self.currentPlayer.name isEqualToString:@"Player 1"]) {
            NSInteger scoreIntValue = [self.player2Score intValue];
            self.player2Score = @(scoreIntValue +1);
            [self updateScoreOfPlayer];
        }
        if ([self.currentPlayer.name isEqualToString:@"Player 2"]) {
            NSInteger scoreIntValue = [self.player1Score intValue];
            self.player1Score = @(scoreIntValue +1);
            [self updateScoreOfPlayer];
        }
        [self selectNextPlayer];
    }
}

-(void)playerLooseLabel {
    SKLabelNode *popupLooseLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(@"You LOOSE!", nil)];
    popupLooseLabel.fontName = @"SnellRoundhand-Black";
    popupLooseLabel.fontColor = [SKColor blueColor];
    popupLooseLabel.position = CGPointMake(self.size.width/2, 220);
    popupLooseLabel.fontSize = 35;
    popupLooseLabel.zPosition = 3;
    [self addChild:popupLooseLabel];
    [self selectNext];
    [self playerWinLabel];
}

-(void)playerWinLabel {
    NSString *playerWin = self.currentPlayer.name;
    playerWin = [playerWin stringByAppendingString:@" WIN!!!"];
    SKLabelNode *playerWinLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(playerWin, nil)];
    playerWinLabel.fontName = @"SnellRoundhand-Black";
    playerWinLabel.fontColor = [SKColor redColor];
    playerWinLabel.position = CGPointMake(self.size.width/2, 170);
    playerWinLabel.fontSize = 35;
    playerWinLabel.zPosition = 3;
    [self addChild:playerWinLabel];
}

-(void)playerSelectPopup {
    SKShapeNode *playerLabelBg = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, 250, 45)];
    playerLabelBg.position = CGPointMake(135, 130);
    playerLabelBg.lineWidth = 1;
    playerLabelBg.strokeColor = [SKColor blackColor];
    playerLabelBg.fillColor = [SKColor blackColor];
    playerLabelBg.alpha = 0.2;
    playerLabelBg.zPosition = 2;
    [self addChild:playerLabelBg];
    
    NSString *playerLabel = self.currentPlayer.name;
    playerLabel = [playerLabel stringByAppendingString:@" turn!"];
    SKLabelNode *playerPopupLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(playerLabel, nil)];
    playerPopupLabel.fontName = @"SnellRoundhand-Black";
    playerPopupLabel.fontColor = [SKColor blueColor];
    playerPopupLabel.position = CGPointMake(260, 140);
    playerPopupLabel.fontSize = 35;
    playerPopupLabel.zPosition = 2;
    [self addChild:playerPopupLabel];
    
    SKAction *fadeAction = [SKAction fadeOutWithDuration:0.75];
    SKAction *delayAction = [SKAction waitForDuration:0.75];
    SKAction *sequence = [SKAction sequence:@[delayAction, fadeAction]];
    
    [playerLabelBg runAction: sequence completion:^{
        [playerLabelBg removeFromParent];
    }];
    [playerPopupLabel runAction: sequence completion:^{
        [playerPopupLabel removeFromParent];
    }];
}

-(void)selectNext {
    NSInteger index = [self.players indexOfObject:self.currentPlayer];
    NSInteger playersCount = [self.players count];
    self.currentPlayer = self.players[(index + 1) % playersCount];
}

-(void)selectNextPlayer {
    NSString *previousColor = self.currentPlayer.color;
    [self selectNext];
    if ([previousColor isEqualToString:@"yellow"]) {
        self.currentPlayer.color = @"red";
    }else if ([previousColor isEqualToString:@"red"]) {
        self.currentPlayer.color = @"yellow";
    }
    [self visualisationCurrentPlayer];
    [self updateScoreOfPlayer];
    [self playerSelectPopup];
}

@end
