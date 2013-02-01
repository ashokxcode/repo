//
//  News.h
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 13/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "TableSubTitleItem.h"
#import "NewsDetailController.h"
#import "GADBannerView.h"

@class GADBannerView;

@interface News : TTTableViewController {
    
    TableSubTitleItem *selectedNewsItem;
    NewsDetailController *newsDetailView;
    GADBannerView *adBanner_;
}

@property (nonatomic, retain) TableSubTitleItem *selectedNewsItem;
@property (nonatomic, retain) NewsDetailController *newsDetailView;
@property (nonatomic, retain) GADBannerView *adBanner;

@end
