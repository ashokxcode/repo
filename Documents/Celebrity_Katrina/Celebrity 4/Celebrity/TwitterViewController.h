//
//  TwitterViewController.h
//  Twitter
//
//  Created by chandramouli shivakumar on 2/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "TwitterWebController.h"
#import "GADBannerView.h"

@class GADBannerView;

@interface TwitterViewController : TTTableViewController {
    
    TwitterWebController *webController;
    GADBannerView *adBanner_;

}
@property (nonatomic, retain) GADBannerView *adBanner;

-(void) refreshTwits;

@end
