//
//  ViewController.h
//  HomeTask10
//
//  Created by Billy on 17.01.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *rubuahLabel;

@property (strong, nonatomic) IBOutlet UILabel *euruahLabel;

@property (strong, nonatomic) IBOutlet UILabel *usduahLabel;

@property (strong, nonatomic) IBOutlet UILabel *uahrubLabel;

@property (strong, nonatomic) IBOutlet UILabel *uaheurLabel;

@property (strong, nonatomic) IBOutlet UILabel *uahusdLabel;

@property (strong, nonatomic) IBOutlet UIPickerView *leftPicker;

@property (strong, nonatomic) IBOutlet UITextField *inputText;

- (IBAction)inputTextchanged:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *convertButton;

- (IBAction)convertComplite:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *resultText;
- (IBAction)EditingResultText:(id)sender;

@property NSArray *PickerDatasource;

@end

