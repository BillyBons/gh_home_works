//
//  ViewController.m
//  HomeTask7
//
//  Created by Billy on 28.11.14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate>

@end

@implementation ViewController

@synthesize scroll;
@synthesize myButton;
@synthesize myLabelButton;
@synthesize mySegmentedControl;
@synthesize myLabelSegmentedControl;
@synthesize myTextField;
@synthesize myLabelTextField;
@synthesize myAlert;
@synthesize MyButtonActivity;
@synthesize myActivityIndicator;
@synthesize myStepper;
@synthesize myStepperLabel;
@synthesize myPictureButton;
@synthesize myImage;
@synthesize mySlider;
@synthesize mySliderLabel;

bool textYesOrNo = YES;
int myStepperValue;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scroll.contentSize = CGSizeMake(320.0f, 800.0f);
    
    myStepper.value = 50;
    myStepperLabel.text = @"50";
    
}

- (IBAction)changeValue{
    if (textYesOrNo == YES) {
        myLabelButton.text = @"Yes";
        textYesOrNo = NO;
    } else{
        myLabelButton.text = @"No";
        textYesOrNo = YES;
    }
}

- (IBAction)mySegmentedControl:(id)sender {
    if (mySegmentedControl.selectedSegmentIndex == 0) {
        myLabelSegmentedControl.text = @"1";}
    else if (mySegmentedControl.selectedSegmentIndex == 1){
            myLabelSegmentedControl.text = @"2";
    }
}


- (IBAction)myTextFieldChanged:(id)sender {
    [myTextField addTarget:self action:@selector(textFieldShouldEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    myLabelTextField.text = myTextField.text;
}

- (IBAction)mySwitch:(id)sender {
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Don't do this anymore!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [myAlert show];
}

- (IBAction)MyButtonActivityClick {
    [myActivityIndicator startAnimating];
}

- (IBAction)myStepperChange {
    myStepperValue = myStepper.value;
    NSString *stepperString = [@(myStepperValue) stringValue];
    myStepperLabel.text = stepperString;
    
   
}


- (IBAction)myPictureButtonClick {
    myImage.image = [UIImage imageNamed:@"GH4.jpg"];
}

- (IBAction)mySliderValueChanged:(id)sender {
    mySliderLabel.text = [NSString stringWithFormat:@"%0.0f", (mySlider.value *100)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
