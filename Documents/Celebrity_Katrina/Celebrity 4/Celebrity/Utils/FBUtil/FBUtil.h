//
//  FBUtil.h
//  FBTester
//
//  Created by Photon on 20/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "FBLoginDialog.h"
#import "FBRequest.h"


@protocol FBSessionDelegate;


@interface FBUtil : NSObject <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate>
{
    Facebook *_facebook;
    NSMutableDictionary *queuedWallData;
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *queuedWallData;

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt ;

- (void) login;//:(NSMutableDictionary*)postData;
- (void) logout;

- (void) postPhotoToWall: (NSMutableDictionary*) wallData;
//- (void) queuePostToWall: (NSMutableDictionary*) wallData;
- (void) shareNewsAndVideo:(NSMutableDictionary*) params;

@end
