//
//  MyUITableViewCell.m
//  ToDoManager
//
//  Created by admin on 2016-10-31.
//  Copyright © 2016 admin. All rights reserved.
//

#import "MyUITableViewCell.h"


@implementation MyUITableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setInternalFields:(ToDoEntity *)incomingToDoEntity {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    self.toDoTitleLabel.text = incomingToDoEntity.toDoTitle;
    
    self.toDoDoneByLabel.text = incomingToDoEntity.toDoDoneBy;
    
    self.toDoLocationLabel.text = incomingToDoEntity.toDoLocation;
    
    self.locaToDoEntity = incomingToDoEntity;
    
   NSString *temp =  [dateFormatter stringFromDate:incomingToDoEntity.toDoDueDate];
    self.toDoDueDateLabel.text = temp;
    
}

@end
