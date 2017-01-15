//
//  MyUITableViewCell.h
//  ToDoManager
//
//  Created by admin on 2016-10-31.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoEntity.h"


@interface MyUITableViewCell : UITableViewCell

@property (strong, nonatomic) ToDoEntity *locaToDoEntity;
@property (weak, nonatomic) IBOutlet UILabel *toDoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDoDueDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDoDoneByLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDoLocationLabel;



-(void) setInternalFields:(ToDoEntity *)incomingToDoEntity;

@end
