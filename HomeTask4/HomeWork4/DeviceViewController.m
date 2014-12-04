//
//  DeviceViewController.m
//  HomeWork4
//
//  Created by Billy on 23.11.14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "DeviceViewController.h"
#import "DetailViewController.h"

@interface DeviceViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) NSArray *iPhones;
@property (strong, nonatomic) NSArray *iPads;

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Apple devices";
    NSArray *iPhones = [NSArray arrayWithObjects:@"iPhone", @"iPhone 3GS", @"iPhone 4", @"iPhone 5", @"iPhone 6", nil];
    NSArray *iPads = [NSArray arrayWithObjects:@"iPad", @"iPad 2", @"iPad 3", @"iPad 4", @"iPad Air", @"iPad Mini", @"iPad Mini 2", @"iPad Mini 3", nil];
    self.iPhones = iPhones;
    self.iPads = iPads;
    
    _myTableView = [[UITableView alloc] init];
    _myTableView.frame = self.view.frame;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview: _myTableView];
    
}

-(void) dealloc {
    self.iPhones = nil;
    self.iPads = nil;
    [super dealloc];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger result;
    if ( section == 0 ) {
        result = [_iPhones count];
    }
    else {
        result = [_iPads count];
    }
    
    return result;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *result  =nil;
    if (section == 0) {
        result = @"iPhones";
    } else {
        result = @"iPads";
    }
    return result;;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0)
        cell.textLabel.text = [self.iPhones objectAtIndex:indexPath.row];
    else
        cell.textLabel.text = [self.iPads objectAtIndex:indexPath.row];
    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *deviceName = selectedCell.textLabel.text;
    
    DetailViewController *detailDeviceViewController = [[DetailViewController alloc] initWithDeviceName: deviceName];
    [self.navigationController pushViewController:detailDeviceViewController animated:YES];
    [detailDeviceViewController release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
