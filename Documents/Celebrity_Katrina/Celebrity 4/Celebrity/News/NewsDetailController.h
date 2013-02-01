//
//  NewsDetailViewController.h
//  CelebrityApp
//
//  Created by JayaPrathap Audikesavalu on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableSubTitleItem.h"
#import "Three20/Three20.h"
//#import "GADBannerViewDelegate.h"
#import "GADBannerView.h"
//#import "GADRequest.h"
#import "NewsWebController.h"

@class GADBannerView;//, GADRequest;

@interface NewsDetailController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate> { 

    UIScrollView *scrollView;
    TableSubTitleItem *currentlySelectedNewsItem;
    UIWebView *descWebView;
    TTImageView *image;
    NSString *contentString;
    UIButton *moreButton;
    UIView *viewUnderline;
    NewsWebController *webController;
    GADBannerView *adBanner_;
}

@property (nonatomic,copy) NSString *contentString;
@property (nonatomic,retain) UIScrollView *scrollView;
@property (readwrite,retain) TableSubTitleItem *currentlySelectedNewsItem;
@property (nonatomic,retain) UIWebView *descWebView;
@property (nonatomic,retain) UIButton *moreButton;
@property (nonatomic,retain) UIView *viewUnderline;
@property (nonatomic,retain) GADBannerView *adBanner;

- (void) initNewsDetailView;

@end
