//
//  GameViewController.m
//  Pool
//
//  Created by Billy on 06.03.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "MainMenu.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    SKView *skView = (SKView *)self.view;
    if (!skView.scene) {
        BOOL isDebug = YES;
        skView.showsFPS = isDebug;
        skView.showsNodeCount = isDebug;
        //skView.showsDrawCount = isDebug;
        skView.showsPhysics = isDebug;

        MainMenu *mainMenu = [[MainMenu alloc] initWithSize:CGSizeMake(568, 320)];

        [skView presentScene:mainMenu];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
