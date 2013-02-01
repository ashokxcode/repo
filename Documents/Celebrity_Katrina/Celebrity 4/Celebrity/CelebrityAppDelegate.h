//
//  CelebrityAppDelegate.h
//  Celebrity
//
//  Created by chandramouli shivakumar on 2/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "Reachability.h"
#import "FBUtil.h"
//#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"

@class RootViewController;

@interface CelebrityAppDelegate : NSObject <UIApplicationDelegate>//, SA_OAuthTwitterEngineDelegate>
{
    Reachability *reachability;
    FBUtil *fbUtil;
    SA_OAuthTwitterEngine *_engine;
}

@property (nonatomic, retain) Reachability *reachability;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) FBUtil *fbUtil;
@property (nonatomic, retain) SA_OAuthTwitterEngine *_engine;
@property (nonatomic, retain) RootViewController *rootViewController;

- (BOOL) isNetworkAvailable;
- (void) setupReachability;

@end
