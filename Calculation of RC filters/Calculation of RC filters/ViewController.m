//
//  ViewController.m
//  Calculation of RC filters
//
//  Created by Billy on 22.11.15.
//  Copyright © 2015 Home. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

const float pi = 3.14;
const float farad_To_mFarad_Ratio = 0.000001;

- (IBAction)beginCalculate:(id)sender {
    //Calculating frequency
    if ((self.resistorChangedSwitch.on & self.capacitorChangedSwitch.on) & (!self.freqChangedSwitch.on)) {
        float result = 1 / (2*pi*[self.resistorLabel.text floatValue]*[self.capacitorLabel.text floatValue]*farad_To_mFarad_Ratio);
        
        self.resultLabel.text = [NSString stringWithFormat:@"Frequency  %1.0f Hz", result];
    }
    //Calculation capacity
    else if ((self.resistorChangedSwitch.on & self.freqChangedSwitch.on) & (!self.capacitorChangedSwitch.on)) {
        float result = 1 / (2*pi*[self.resistorLabel.text floatValue]*[self.cutOffFreqLabel.text floatValue]*farad_To_mFarad_Ratio);
        self.resultLabel.text = [NSString stringWithFormat:@"Capacitor  %1.6f mF", result];
    }
    //Calculation resistor
    else if ((self.capacitorChangedSwitch.on & self.freqChangedSwitch.on) & (!self.resistorChangedSwitch.on)) {
        float result = 1 / (2*pi*[self.cutOffFreqLabel.text floatValue]*[self.capacitorLabel.text floatValue]*farad_To_mFarad_Ratio);
        self.resultLabel.text = [NSString stringWithFormat:@"Resistor  %1.0f Ohm", result];
    }
    else {
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Please, enter any two value!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [myAlert show];
        [self reset];
    }
    
}

- (IBAction)freqValueCanged:(id)sender {
    self.freqChangedSwitch.on = YES;
}

- (IBAction)resistorValueChanged:(id)sender {
    self.resistorChangedSwitch.on = YES;
}

- (IBAction)capacitorValueChanged:(id)sender {
    self.capacitorChangedSwitch.on = YES;
}

- (IBAction)resetResult:(id)sender {
    [self reset];
}

-(void)reset{
    self.resultLabel.text = @"You result";
    self.cutOffFreqLabel.text = nil;
    self.resistorLabel.text = nil;
    self.capacitorLabel.text = nil;
    self.freqChangedSwitch.on = NO;
    self.resistorChangedSwitch.on = NO;
    self.capacitorChangedSwitch.on = NO;
    [self.resistorLabel resignFirstResponder];
    [self.capacitorLabel resignFirstResponder];
    [self.cutOffFreqLabel resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
