//
//  ViewController.h
//  HomeTask12_1
//
//  Created by Billy on 13.02.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "CoreData+MagicalRecord.h"
#import "AFNetworking.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet FLAnimatedImageView *myQuantumLogo;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIAlertView *connectionAlert;

- (IBAction)clearNumbersButton:(id)sender;

@end

