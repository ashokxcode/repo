//
//  RootViewController.h
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 12/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "AlbumController.h"
#import "News.h"
#import "VideosViewController.h"
#import "GADBannerViewDelegate.h"
#import "SA_OAuthTwitterController.h"
#import "OAServiceTicket.h"
#import "OAAsynchronousDataFetcher.h"
#import "SA_OAuthTwitterEngine.h"
#import "DragDropViewController.h"

@class GADBannerView, GADRequest;

@interface RootViewController : UIViewController <GADBannerViewDelegate, 
SA_OAuthTwitterControllerDelegate,
SA_OAuthTwitterEngineDelegate>{

    //int selectedIndex;
    UIView *initialView;
    
    UINavigationController *selectedController;
    GADBannerView *adBanner_;
}
//@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, retain) UINavigationController *selectedController;
@property (nonatomic, retain) GADBannerView *adBanner;

-(void)shareLinkInFacebook:(NSNotification*)notification;
-(void)shareLinkInTwitter:(NSNotification*)notification;

-(void)loginToTwitter;
-(void)replyToTweet:(NSNotification*)notification;

-(void)sendStatus;
-(void)sendImageTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
-(void)sendImageTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;

-(void) addLoadingView;
-(void) removeLoadingView;
-(void) enableUserInteraction;

-(BOOL) isNetworkAvailable;
-(void) setupReachability;

-(void) showView;
-(void) removeLoader;
-(void) enableTouch;

-(void) getNewsInfo;
-(void) getPhotoInfo;
-(void) twitterResponseObtained:(NSMutableArray*) twitterResponse;

@end
