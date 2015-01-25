//
//  ViewController.m
//  HomeTask10
//
//  Created by Billy on 17.01.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "ViewController.h"

#import "Currency.h"

@interface ViewController ()<NSURLConnectionDataDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation ViewController

@synthesize rubUahLabel;

@synthesize eurUahLabel;

@synthesize usdUahLabel;

@synthesize uahRubLabel;

@synthesize uahEurLabel;

@synthesize uahUsdLabel;

@synthesize myPicker;

@synthesize pickerDataSource;

@synthesize inputText;

@synthesize convertButton;

@synthesize resultText;

//NSArray *arrayCarrencys;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.pickerDataSource = [NSArray arrayWithObjects:@"UAH", @"RUR", @"EUR", @"USD", nil];
    
    NSURL *url = [NSURL URLWithString:@"https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
 
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
   
    NSArray *currencys = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
       
    NSMutableArray *currencies = [NSMutableArray array];
    
    for (NSDictionary *current in currencys){
        Currency *currency = [Currency new];
        [currency setValuesForKeysWithDictionary:current];
        [currencies addObject:currency];
    }
    
    Currency *currency = currencies[0];
    rubUahLabel.text = currency.buy;
    uahRubLabel.text = currency.sale;
    
    currency = currencies[1];
    eurUahLabel.text = currency.buy;
    uahEurLabel.text = currency.sale;
    
    currency = currencies[2];
    usdUahLabel.text = currency.buy;
    uahUsdLabel.text = currency.sale;
 
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerDataSource count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerDataSource objectAtIndex:row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)inputTextchanged:(id)sender {
    [inputText addTarget:self action:@selector(textFieldShouldEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    }

- (IBAction)convertComplete:(id)sender {
    
    
    if ([myPicker selectedRowInComponent:0] == [myPicker selectedRowInComponent:1]) {resultText.text = inputText.text;}
    
    
    if ([myPicker selectedRowInComponent:0] == 0 & [myPicker selectedRowInComponent:1] == 1) {
        resultText.text = [NSString stringWithFormat:@"%0.2f", inputText.text.integerValue/uahRubLabel.text.floatValue];}
    if ([myPicker selectedRowInComponent:0] == 0 & [myPicker selectedRowInComponent:1] == 2) {
        resultText.text = [NSString stringWithFormat:@"%0.2f", inputText.text.integerValue/uahEurLabel.text.floatValue];}
    if ([myPicker selectedRowInComponent:0] == 0 & [myPicker selectedRowInComponent:1] == 3) {
        resultText.text = [NSString stringWithFormat:@"%0.2f", inputText.text.integerValue/uahUsdLabel.text.floatValue];}
    
    if ([myPicker selectedRowInComponent:0] == 1 & [myPicker selectedRowInComponent:1] == 0) {
        resultText.text = [NSString stringWithFormat:@"%0.2f", inputText.text.integerValue*rubUahLabel.text.floatValue];}
    if ([myPicker selectedRowInComponent:0] == 1 & [myPicker selectedRowInComponent:1] == 2) {
        resultText.text = [NSString stringWithFormat:@"%0.2f", inputText.text.integerValue*rubUahLabel.text.floatValue/uahEurLabel.text.floatValue];}
    if ([myPicker selectedRowInComponent:0] == 1 & [myPicker selectedRowInComponent:1] == 3) {
        resultText.text = [NSString stringWithFormat:@"%0.2f", inputText.text.integerValue*rubUahLabel.text.floatValue/uahUsdLabel.text.floatValue];}
    
    if ([myPicker selectedRowInComponent:0] == 2 & [myPicker selectedRowInComponent:1] == 0) {
        resultText.text = [NSString stringWithFormat:@"%0.2f", inputText.text.integerValue*eurUahLabel.text.floatValue];}
    if ([myPicker selectedRowInComponent:0] == 2 & [myPicker selectedRowInComponent:1] == 1) {
        resultText.text = [NSString stringWithFormat:@"%0.2f", inputText.text.integerValue*eurUahLabel.text.floatValue/uahRubLabel.text.floatValue];}
    if ([myPicker selectedRowInComponent:0] == 2 & [myPicker selectedRowInComponent:1] == 3) {
        resultText.text = [NSString stringWithFormat:@"%0.2f", inputText.text.integerValue*eurUahLabel.text.floatValue/uahUsdLabel.text.floatValue];}
    
    if ([myPicker selectedRowInComponent:0] == 3 & [myPicker selectedRowInComponent:1] == 0) {
        resultText.text = [NSString stringWithFormat:@"%0.2f", inputText.text.integerValue*usdUahLabel.text.floatValue];}
    if ([myPicker selectedRowInComponent:0] == 3 & [myPicker selectedRowInComponent:1] == 1) {
        resultText.text = [NSString stringWithFormat:@"%0.2f", inputText.text.integerValue*usdUahLabel.text.floatValue/uahRubLabel.text.floatValue];}
    if ([myPicker selectedRowInComponent:0] == 3 & [myPicker selectedRowInComponent:1] == 2) {
        resultText.text = [NSString stringWithFormat:@"%0.2f", inputText.text.integerValue*usdUahLabel.text.floatValue/uahEurLabel.text.floatValue];}
    
}

@end
