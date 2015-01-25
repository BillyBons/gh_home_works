//
//  ViewController.h
//  HomeTask10
//
//  Created by Billy on 17.01.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *rubUahLabel;

@property (strong, nonatomic) IBOutlet UILabel *eurUahLabel;

@property (strong, nonatomic) IBOutlet UILabel *usdUahLabel;

@property (strong, nonatomic) IBOutlet UILabel *uahRubLabel;

@property (strong, nonatomic) IBOutlet UILabel *uahEurLabel;

@property (strong, nonatomic) IBOutlet UILabel *uahUsdLabel;

@property (strong, nonatomic) IBOutlet UIPickerView *myPicker;

@property (strong, nonatomic) IBOutlet UITextField *inputText;

- (IBAction)inputTextchanged:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *convertButton;

- (IBAction)convertComplete:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *resultText;

@property NSArray *pickerDataSource;

@end

