//
//  MyUITableViewController.m
//  ToDoManager
//
//  Created by admin on 2016-10-31.
//  Copyright © 2016 admin. All rights reserved.
//

#import "MyUITableViewController.h"
#import <CoreData/CoreData.h>
#import "ToDoEntity.h"
#import "MyUITableViewCell.h"

@interface MyUITableViewController () <NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong,nonatomic) ToDoEntity *localToDoEntity;

@property (strong,nonatomic) NSFetchedResultsController *resultsController;
@end

@implementation MyUITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeNSFetchedResultsControllerDelegate];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultsController.sections[section].numberOfObjects;
    
}

-(void) initializeNSFetchedResultsControllerDelegate{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"ToDoEntity" inManagedObjectContext:self.managedObjectContext];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    
    
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"toDoTitle" ascending:YES]];
    
    self.resultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    self.resultsController.delegate = self;
    
    NSError *err;
    
    BOOL fetchSucceeded = [self.resultsController performFetch:&err];
    
    if(!fetchSucceeded){
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Couldn't fetch" userInfo:nil];
    }
    
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ToDoEntity *item = self.resultsController.sections[indexPath.section].objects[indexPath.row];
    
    MyUITableViewCell *cell = (MyUITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TableCellIdentifier"forIndexPath:indexPath];
    
    [cell setInternalFields:item];
    
    // Configure the cell...
    
    return cell;
}

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*) indexPath forChangeType:(NSFetchedResultsChangeType) type newIndexPath:(NSIndexPath *)newIndexPath
{
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [[self tableView]insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    
case NSFetchedResultsChangeDelete:
    [[self tableView]deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
        case NSFetchedResultsChangeUpdate:{
         
            
            MyUITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            ToDoEntity *item = [controller objectAtIndexPath:indexPath];
            
            [cell setInternalFields:item];
            
        
            
            break;
        }
       
            case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [[self tableView] insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
            
}


}

-(void) receiveToDoEntity:(ToDoEntity *)incomingToDoEntity{
    self.localToDoEntity = incomingToDoEntity;
    
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id<SRHandlesMOC,SRHandlesToDoEntity> child = (id<SRHandlesMOC,SRHandlesToDoEntity>)[segue destinationViewController];
    [child receiveMOC:self.managedObjectContext];
    
    ToDoEntity *item;
    
    if([sender isMemberOfClass:[UIBarButtonItem class]]) { // Called from "+" Button
        
          item = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoEntity" inManagedObjectContext:self.managedObjectContext];
        
    }
    
    else { // Called by tapping table cell
        
        MyUITableViewCell *source = (MyUITableViewCell *) sender;
        item = source.locaToDoEntity;
    }
    
  
    [child receiveToDoEntity:item];
}


-(void) receiveMOC:(NSManagedObjectContext *)incomingMOC {
    self.managedObjectContext = incomingMOC;
    
}


@end
