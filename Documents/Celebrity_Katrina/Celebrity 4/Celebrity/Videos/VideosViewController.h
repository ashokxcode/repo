//
//  VideosViewController.h
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "ServiceHandler.h"
#import "Videos.h"
#import "GADBannerView.h"

@class GADBannerView;

@interface VideosViewController : TTTableViewController {

    Videos *videos;
    GADBannerView *adBanner_;
}
@property (nonatomic, retain) Videos *videos;
@property (nonatomic,retain) GADBannerView *adBanner;

@end
