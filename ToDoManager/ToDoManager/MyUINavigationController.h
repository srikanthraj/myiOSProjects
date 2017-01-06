//
//  MyUINavigationController.h
//  ToDoManager
//
//  Created by admin on 2016-10-31.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRHandlesMOC.h"

@interface MyUINavigationController : UINavigationController <SRHandlesMOC>

-(void) receiveMOC:(NSManagedObjectContext *)incomingMOC;

@end
