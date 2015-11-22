//
//  ViewController.m
//  TableTest
//
//  Created by Billy on 21.11.15.
//  Copyright © 2015 Home. All rights reserved.
//

#import "ViewController.h"
#import "DetailInfoViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *countriesTableView;
@property (strong, nonatomic) NSArray *countries;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Countries";
    NSArray *countriesArray = [NSArray arrayWithObjects:@"Ukraine", @"Poland", @"Romania", @"Hungary", @"Turkey", nil];
    self.countries = countriesArray;
    
    self.countriesTableView = [UITableView new];
    self.countriesTableView.frame = self.view.frame;
    self.countriesTableView.delegate = self;
    self.countriesTableView.dataSource = self;
    [self.view addSubview:self.countriesTableView];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.countries count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.countries objectAtIndex:indexPath.row];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *countryName = selectedCell.textLabel.text;
    
    DetailInfoViewController *detailCountryInfo = [[DetailInfoViewController alloc] initWithCountryName:countryName];
    [self.navigationController pushViewController:detailCountryInfo animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
