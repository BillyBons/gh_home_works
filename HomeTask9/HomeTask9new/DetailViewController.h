//
//  DetailViewController.h
//  HomeTask9new
//
//  Created by Billy on 27.12.14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MasterViewController.h"

@interface DetailViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UITextField *editTask;

@property (strong) NSManagedObject *editedTask;

- (IBAction)changingTask:(id)sender;


- (IBAction)cancel:(id)sender;

- (IBAction)save:(id)sender;


@end

