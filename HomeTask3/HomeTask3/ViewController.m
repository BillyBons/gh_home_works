//
//  ViewController.m
//  HomeTask3
//
//  Created by Billy on 16.11.14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "ViewController.h"
@interface ViewController()<UITableViewDataSource> {

}
@property (strong, nonatomic) UITableView *codeTable;
//для цієї я залінкував її до торібоарда і її датасорс залінкував
@property (weak, nonatomic) IBOutlet UITableView *interfaceTable;

@property (strong, nonatomic) NSArray *cars;
@property (strong, nonatomic) NSArray *bikes;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	//Инициализация массива на пряму не до пропертей а до змінних можна замінити на self.
	_cars = [[NSArray alloc] initWithObjects:@"Toyota", @"Subaru", @"BMW", @"Mercedes", nil];
	_bikes = [[NSArray alloc] initWithObjects:@"Suzuki",@"Honda",@"Kawasaki",@"Yamaha",nil];


	//Додаєм програмну
	[self addTableView];
}
- (void) addTableView {
	_codeTable = [[UITableView alloc] init];
	CGRect halfFrame = self.view.frame;
	halfFrame.size.width = halfFrame.size.width/2;
	halfFrame.origin.x = halfFrame.size.width;
	_codeTable.frame = halfFrame;
	_codeTable.dataSource = self;
	
	[self.view addSubview:_codeTable];
}

- (NSArray *) arrayForTableView:(UITableView *)table {
	if (table == _codeTable) {
		return _cars;
	}
	return _bikes;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	//тут ми не знаєм ще показувать байки чи машини значить треба узнать яка тейбл вю питає селл щоб вернуть правельний еррей
	NSArray *array = [self arrayForTableView:tableView];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

	//тут ми не знаєм ще показувать байки чи машини значить треба узнать яка тейбл вю питає селл щоб вернуть правельний еррей
	NSArray *array = [self arrayForTableView:tableView];
	
	cell.textLabel.text = [array objectAtIndex:indexPath.row];
    return cell;
}

@end
