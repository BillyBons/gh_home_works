//
//  DetailViewController.m
//  HomeWork4
//
//  Created by Billy on 20.11.14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, assign) UIWebView *webView;

@end

@implementation DetailViewController

-(instancetype) initWithDeviceName:(NSString*) devName {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) {
        return nil;
    }
    
    self.deviceName = devName;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    self.webView = webView;
    [webView release];
    
    NSString *urlPath = [NSString stringWithFormat:@"https://en.wikipedia.org/wiki/%@", self.deviceName];
    urlPath = [urlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    return self;
    
}

-(void) dealloc {
    self.deviceName = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.deviceName;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
