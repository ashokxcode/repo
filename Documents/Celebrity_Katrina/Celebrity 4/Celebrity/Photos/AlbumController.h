//
//  AlbumController.h
//  Three20PhotoGallery
//
//  Created by JayaPrathap Audikesavalu on 13/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "PhotoViewController.h"
//#import "GADBannerViewDelegate.h"
#import "GADBannerView.h"
//#import "GADRequest.h"

@class GADBannerView;//, GADRequest;

@interface AlbumController : TTThumbsViewController {

    PhotoViewController *photoView;
    GADBannerView *adBanner_;
}

@property (nonatomic, retain) PhotoViewController *photoView;
@property (nonatomic, retain) GADBannerView *adBanner;

-(NSString*) URLForPhoto:(id<TTPhoto>)photo;

@end
