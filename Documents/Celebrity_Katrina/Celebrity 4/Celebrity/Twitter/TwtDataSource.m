//
//  TwtDataSource.m
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwtDataSource.h"
#import "TwitterTableItem.h"
#import "TwitterItemCell.h"
#import "SharedObjects.h"

@implementation TwtDataSource

+ (TwtDataSource*) twitterDataSource {
    
    TwtDataSource* dataSource =  [[[TwtDataSource alloc] initWithItems:[[SharedObjects sharedInstance] twitterArray]] autorelease];
    
    return dataSource;  
}

- (void)dealloc {  
    [super dealloc];  
}  

///////////////////////////////////////////////////////////////////////////////////////////////////  
// TTTableViewDataSource  

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object {  
    
    if ([object isKindOfClass:[TwitterTableItem class]]) {  
        return [TwitterItemCell class];  
    }
    else {  
        return [super tableView:tableView cellClassForObject:object];  
    }    
}  

- (void)tableView:(UITableView*)tableView 
      prepareCell:(UITableViewCell*)cell  
forRowAtIndexPath:(NSIndexPath*)indexPath {  
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  
}  

@end
