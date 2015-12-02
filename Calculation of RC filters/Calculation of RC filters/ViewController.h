//
//  ViewController.h
//  Calculation of RC filters
//
//  Created by Billy on 22.11.15.
//  Copyright © 2015 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *calculateButton;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) IBOutlet UITextField *cutOffFreqLabel;
@property (strong, nonatomic) IBOutlet UITextField *resistorLabel;
@property (strong, nonatomic) IBOutlet UITextField *capacitorLabel;

@property (strong, nonatomic) IBOutlet UISwitch *freqChangedSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *resistorChangedSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *capacitorChangedSwitch;

@end

