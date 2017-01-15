//
//  MyUITableViewController.h
//  ToDoManager
//
//  Created by admin on 2016-10-31.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRHandlesMOC.h"
#import "SRHandlesToDoEntity.h"


@interface MyUITableViewController : UITableViewController <SRHandlesMOC>

-(void) receiveMOC:(NSManagedObjectContext *)incomingMOC;
//-(void) receiveToDoEntity:(ToDoEntity *)incomingToDoEntity;

@end
