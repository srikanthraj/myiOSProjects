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

@property (weak, nonatomic) IBOutlet UITextView *detailsField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dueDateField;

@property (nonatomic,assign) BOOL wasDeleted;
@end

@implementation MyUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

-(void) receiveMOC:(NSManagedObjectContext *)incomingMOC {
    self.managedObjectContext = incomingMOC;
    
}


-(void) receiveToDoEntity:(ToDoEntity *) incomingToDoEntity{
    self.localToDoEntity = incomingToDoEntity;
}


-(void) textViewDidEndEditing:(NSNotification *) notification {
    
    
    if([notification object] == self){
        self.localToDoEntity.toDoDetails = self.detailsField.text;
        [self saveMyToDoEntity];
    }
}

- (IBAction)trashTapped:(id)sender {
    
    self.wasDeleted = YES;
    [self.managedObjectContext deleteObject:self.localToDoEntity];
    [self saveMyToDoEntity];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    
    //Setup delete state
    self.wasDeleted = NO;
    //Setup Form
    self.titleField.text = self.localToDoEntity.toDoTitle;
    self.detailsField.text = self.localToDoEntity.toDoDetails;
    NSDate *dueDate = self.localToDoEntity.toDoDueDate;
    if(dueDate!=nil){
        [self.dueDateField setDate:dueDate];
    }
    //Detect edit ends
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];

}

-(void) viewWillDisappear:(BOOL)animated{
    
    if(self.wasDeleted == NO)
    {
    
    //Save Everything
    
    self.localToDoEntity.toDoTitle = self.titleField.text;
    self.localToDoEntity.toDoDetails = self.detailsField.text;
    self.localToDoEntity.toDoDueDate = self.dueDateField.date;
    [self saveMyToDoEntity];
        }
    //Remove detection
    
    else {
        NSLog(@"Going Here");
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidEndEditingNotification object:self];

    
}

-(void) saveMyToDoEntity {
    
    NSError *err;
    BOOL saveSuccess = [self.managedObjectContext save:&err];
    if(!saveSuccess) {
        @throw[NSException exceptionWithName:NSGenericException reason:@"Couldn't Save" userInfo:@{NSUnderlyingErrorKey:err}];
    }
    
}

- (IBAction)titleFieldEdited:(id)sender {
    
    self.localToDoEntity.toDoTitle = self.titleField.text;
    [self saveMyToDoEntity];
}

- (IBAction)dueDateEdited:(id)sender {
    self.localToDoEntity.toDoDueDate = self.dueDateField.date;
    [self saveMyToDoEntity];
    
}

@end
