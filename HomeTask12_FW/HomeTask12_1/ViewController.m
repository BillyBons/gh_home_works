//
//  ViewController.m
//  HomeTask12_1
//
//  Created by Billy on 13.02.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "ViewController.h" 
#import "QuantumNumber.h"


@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *numbers;
@property (nonatomic, strong) QuantumNumber *number;
@property (nonatomic, strong) UIRefreshControl *refresh;
@property (nonatomic, strong) NSData *myData;
@property (nonatomic, strong) NSString *recivedNumber;

@end

@implementation ViewController

@synthesize myQuantumLogo;

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self animatedLogo];
  
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    self.refresh = refresh;
    [self.tableView addSubview:self.refresh];
    [self.refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self fetchNumbers];
}

- (BOOL)connected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

-(void) refresh:(id)sender{
    if (self.connected) {
        NSURL *url = [NSURL URLWithString:@"https://qrng.anu.edu.au/API/jsonI.php?length=1&type=uint8"];
        NSURLRequest *webrequest = [NSURLRequest requestWithURL:url];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:webrequest delegate:self];
        [connection start];
    }
    else {
        self.connectionAlert = [[UIAlertView alloc] initWithTitle:@"NO internet connection!" message:@"Quantum random generator need internet connection!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.connectionAlert show];
        [self.refresh endRefreshing];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    self.myData = data;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
  NSDictionary *myQuantumNumbers = [NSJSONSerialization JSONObjectWithData:self.myData options:NSJSONReadingMutableContainers error:nil];
    NSArray *myRecivedArray = myQuantumNumbers[@"data"];
    self.recivedNumber = myRecivedArray[0];
    if (![self.numbers containsObject:self.recivedNumber]) {
        [self reciveQuantumNumber];
    }
    else [self.refresh endRefreshing];
}

-(void)fetchNumbers{
    self.numbers = [NSMutableArray arrayWithArray:[QuantumNumber MR_findAllSortedBy:@"number" ascending:YES]];
}

-(void)reciveQuantumNumber{
    self.number = [QuantumNumber MR_createEntity];
    [self.number setNumber:[NSString stringWithFormat:@"%@",self.recivedNumber]];
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
    [self.refresh endRefreshing];
    [self fetchNumbers];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.numbers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    QuantumNumber *cellNumber = [self.numbers objectAtIndex:[indexPath row]];
    [cell.textLabel setText:[cellNumber number]];
    return cell;
}

-(void)animatedLogo{
    FLAnimatedImage *quantumLogo = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vacuum_big" ofType:@"gif"]]];
    self.myQuantumLogo.animatedImage = quantumLogo;
    [self.view addSubview:myQuantumLogo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)clearNumbersButton:(id)sender {
    [QuantumNumber MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
    [self fetchNumbers];
    [self.tableView reloadData];
}
@end
