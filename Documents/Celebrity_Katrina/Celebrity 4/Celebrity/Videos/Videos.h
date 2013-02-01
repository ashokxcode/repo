//
//  Videos.h
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 13/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "TableSubTitleItem.h"
#import "TableSubTitleItemCell.h"
//#import "GADBannerViewDelegate.h"
#import "GADBannerView.h"
//#import "GADRequest.h"

@class GADBannerView;//, GADRequest;

@interface Videos : TTTableViewController {

    TableSubTitleItem *selectedVideoItem;
    GADBannerView *adBanner_;
}
@property (nonatomic, retain) TableSubTitleItem *selectedVideoItem;
@property (nonatomic, retain) GADBannerView *adBanner;

- (void) shareThis:(id) sender;
- (void) tweetThis:(id) sender;

@end
