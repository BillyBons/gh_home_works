//
//  DetailInfoViewController.m
//  TableTest
//
//  Created by Billy on 21.11.15.
//  Copyright © 2015 Home. All rights reserved.
//

#import "DetailInfoViewController.h"

@interface DetailInfoViewController ()

@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, assign) UIWebView *webView;

@end

@implementation DetailInfoViewController

-(instancetype) initWithCountryName:(NSString*) countryName{
    self = [super initWithNibName:nil bundle:nil];
    if (!self){
        return nil;
    }
    self.countryName = countryName;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    self.webView = webView;
    
    NSString *urlPath = [NSString stringWithFormat:@"https://en.wikipedia.org/wiki/%@", self.countryName];
    urlPath = [urlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.countryName;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
