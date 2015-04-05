//
//  GameViewController.m
//  Pool
//
//  Created by Billy on 06.03.15.
//  Copyright (c) 2015 Billy. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        BOOL isDebug = NO;
        skView.showsFPS = isDebug;
        skView.showsNodeCount = isDebug;
        //skView.showsDrawCount = isDebug;
        skView.showsPhysics = isDebug;
        // Create and configure the scene.
        SKScene * scene = [GameScene sceneWithSize:CGSizeMake(568, 320)];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        //NSLog(@"Wight: %f", skView.bounds.size.width);
        //NSLog(@"Height: %f", skView.bounds.size.height);
        // Present the scene.
        [skView presentScene:scene];
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
