//
//  VideoDataSource.m
//  CelebrityApp
//
//  Created by JayaPrathap Audikesavalu on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoDataSource.h"
#import "SharedObjects.h"
#import "TableTextItemCell.h"
#import "TableSubTitleItem.h"
#import "TableSubTitleItemCell.h"

@implementation VideoDataSource

+ (VideoDataSource*)rootViewDataSource {
    
    VideoDataSource* dataSource =  [[[VideoDataSource alloc] initWithItems:[[SharedObjects sharedInstance] videoSource]] autorelease];
    
    return dataSource;  
}  

+ (VideoDataSource*)playListDataSource {
    
    VideoDataSource* dataSource =  [[[VideoDataSource alloc] initWithItems:[[SharedObjects sharedInstance] playlistNamesArray]] autorelease];
    
    return dataSource;  
}
///////////////////////////////////////////////////////////////////////////////////////////////////  

- (void)dealloc {  
    [super dealloc];  
}  

///////////////////////////////////////////////////////////////////////////////////////////////////  
// TTTableViewDataSource  

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object {  
    
    if ([object isKindOfClass:[TableSubTitleItem class]]) {  
        return [TableSubTitleItemCell class];  
    }
    else if ([object isKindOfClass:[TTTableTextItem class]]) {
        return [TableTextItemCell class];
    }
    else if ([object isKindOfClass:[TTTableSubtitleItem class]]) {
        return [TableSubTitleItem class];
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
