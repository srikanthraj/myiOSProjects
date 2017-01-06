//
//  SRHandlesMOC.h
//  ToDoManager
//
//  Created by admin on 2016-10-31.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SRHandlesMOC <NSObject>

-(void) receiveMOC:(NSManagedObjectContext *)incomingMOC;

@end
