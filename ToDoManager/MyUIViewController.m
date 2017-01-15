//
//  MyUIViewController.m
//  ToDoManager
//
//  Created by admin on 2016-10-31.
//  Copyright © 2016 admin. All rights reserved.
//

#import "MyUIViewController.h"

@interface MyUIViewController ()
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) ToDoEntity *localToDoEntity;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *doneByField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;

@property (weak, nonatomic) IBOutlet UITextView *detailsField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dueDateField;

@property (nonatomic,assign) BOOL wasDeleted;

@end

@implementation MyUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



-(void)viewWillAppear:(BOOL)animated {
    
    //Setup delete state
    self.wasDeleted = NO;
    
    //Setup Form
    self.titleField.text = self.localToDoEntity.toDoTitle;
    self.detailsField.text = self.localToDoEntity.toDoDetails;
    
    self.doneByField.text = self.localToDoEntity.toDoDoneBy;
    self.locationField.text = self.localToDoEntity.toDoLocation;
    
    NSDate *dueDate = self.localToDoEntity.toDoDueDate;
    if(dueDate != nil){
        [self.dueDateField setDate:dueDate];
    }
    
    //Detect edit ends of text Views by notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    
}

-(void) saveMyToDoEntity {
    
    NSError *err;
    BOOL saveSuccess = [self.managedObjectContext save:&err];
    if(!saveSuccess) {
        @throw[NSException exceptionWithName:NSGenericException reason:@"Couldn't Save" userInfo:@{NSUnderlyingErrorKey:err}];
    }
    
}


-(void) textViewDidEndEditing:(NSNotification *) notification {
    
    
    if([notification object] == self){
        self.localToDoEntity.toDoDetails = self.detailsField.text;
        [self saveMyToDoEntity];
    }
}


- (IBAction)titleFieldEdited:(id)sender {
    
    self.localToDoEntity.toDoTitle = self.titleField.text;
    [self saveMyToDoEntity];
}

- (IBAction)doneByFieldEdited:(id)sender {
    
    self.localToDoEntity.toDoDoneBy = self.doneByField.text;
    [self saveMyToDoEntity];
}

- (IBAction)locationFieldEdited:(id)sender {
    
    self.localToDoEntity.toDoLocation = self.locationField.text;
    [self saveMyToDoEntity];
}



- (IBAction)dueDateEdited:(id)sender {
    self.localToDoEntity.toDoDueDate = self.dueDateField.date;
    [self saveMyToDoEntity];
    
}


- (IBAction)trashTapped:(id)sender {
    
    
    self.wasDeleted = YES;
    [self.managedObjectContext deleteObject:self.localToDoEntity];
    [self saveMyToDoEntity];
    
[self.navigationController popToRootViewControllerAnimated:YES];
}


-(void) viewWillDisappear:(BOOL)animated{
    
    if(self.wasDeleted == NO)
    {
    
    //Save Everything
    
    self.localToDoEntity.toDoTitle = self.titleField.text;
    self.localToDoEntity.toDoDetails = self.detailsField.text;
    self.localToDoEntity.toDoDoneBy = self.doneByField.text;
    self.localToDoEntity.toDoLocation = self.locationField.text;
    self.localToDoEntity.toDoDueDate = self.dueDateField.date;
    [self saveMyToDoEntity];
    
    }
    //Remove detection
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidEndEditingNotification object:self];

}


-(void) receiveMOC:(NSManagedObjectContext *)incomingMOC {
    self.managedObjectContext = incomingMOC;
    
}


-(void) receiveToDoEntity:(ToDoEntity *) incomingToDoEntity{
    self.localToDoEntity = incomingToDoEntity;
}


@end
