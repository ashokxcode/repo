//
//  TableTextItemCell.m
//  CelebrityApp
//
//  Created by JayaPrathap Audikesavalu on 09/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableTextItemCell.h"

@implementation TableTextItemCell

- (id)object {  
    return _item;  
}  

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {  

    CGFloat height = 0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        height = 80;
    }
    else {
        height = 45;
    } 
    
    return height;
}  

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {  
    if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {  
        _item = nil;  
        
        [self.contentView addSubview:self.textLabel];
    }  
    return self;  
}  

- (void)layoutSubviews {  
    [super layoutSubviews];  
    
}  

- (void)dealloc {  
    [super dealloc];  
}  

- (void)setObject:(id)object {  
   
    if (_item != object) {  
    
        [super setObject:object];  
        
        TTTableTextItem* item = object;  

        self.textLabel.text = item.text;
        self.textLabel.textColor = [UIColor whiteColor];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        }
        else {
            self.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        }
        
        self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }  
}  

@end
