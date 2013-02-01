//
//  NewsDataSource.m
//  CelebrityApp
//
//  Created by JayaPrathap Audikesavalu on 06/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsDataSource.h"
#import "SharedObjects.h"
#import "TableSubTitleItem.h"
#import "NewsTableItemCell.h"
//#import "TwitterTableItem.h"
//#import "TwitterItemCell.h"

@implementation NewsDataSource

+ (NewsDataSource*)newsDataSource {
    
    NewsDataSource* dataSource =  [[[NewsDataSource alloc] initWithItems:[[SharedObjects sharedInstance] newsArray]] autorelease];
   
    return dataSource;  
} 

- (void)dealloc {  
    [super dealloc];  
}  

///////////////////////////////////////////////////////////////////////////////////////////////////  
// TTTableViewDataSource  

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object {  
    
    if ([object isKindOfClass:[TableSubTitleItem class]]) {  
        return [NewsTableItemCell class];  
    }
//    else if ([object isKindOfClass:[TwitterTableItem class]]) {
//        return [TwitterItemCell class];
//    }
    else {  
        return [super tableView:tableView cellClassForObject:object];  
    }  
}  

- (void)tableView:(UITableView*)tableView prepareCell:(UITableViewCell*)cell  
                                    forRowAtIndexPath:(NSIndexPath*)indexPath {  
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  
}  

@end
