//
//  DetailViewController.m
//  HomeTask9new
//
//  Created by Billy on 27.12.14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize editTask;

@synthesize editedTask;

@synthesize TaskSwitch;

NSString *task;


#pragma mark - Managing the detail item

/*- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
    }
}*/

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *completeTask;
    completeTask = [self.editedTask valueForKey:@"completed"];
    if ([completeTask isEqualToString:@"1"]) {
        [TaskSwitch setOn:YES animated:YES];
    }
    else if ([completeTask isEqualToString:@"0"]){
        [TaskSwitch setOn:NO animated:YES];
    }
    //[TaskSwitch setOn:NO animated:YES];
    if(self.editedTask) {
        [self.editTask setText:[self.editedTask valueForKey:@"todo"]];
        task = [self.editedTask valueForKey:@"todo"];
    }
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
    //[self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)changingTask:(id)sender {
    [editTask addTarget:self action:@selector(textFieldShouldEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    task = [self.editedTask valueForKey:@"todo"];
    task = editTask.text;
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
     if(self.editedTask) {
        [self.editedTask setValue:task forKey:@"todo"];
        //task = nil;
    }
    
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)ComletedTaskSwitch:(id)sender {
    NSString *completedValue;
    completedValue = [self.editedTask valueForKey:@"completed"];
    
    if ([completedValue isEqualToString:@"1"]) {
        
        [self.editedTask setValue:@"0" forKey:@"completed"];
    }
    else if ([completedValue isEqualToString:@"0"]){
        
    [self.editedTask setValue:@"1" forKey:@"completed"];
    }
 }



@end
