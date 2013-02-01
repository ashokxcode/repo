//
//  SharedObjects.h
//  iShop3.0
//
//  Created by Admin on 11/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@class ServiceResponse;

@interface SharedObjects : NSObject {
    
    ServiceResponse *serviceResponse;
    NSMutableArray *videoSource;
    NSMutableArray *newsArray;
    NSMutableDictionary *tweetDetails;
    NSArray *playlistNamesArray;
    NSMutableDictionary *playlistIdDict; 
    NSMutableArray *picsArray;
    id<TTPhotoSource> photoSource;
    NSMutableArray *twitterArray;
    NSMutableDictionary *serviceDownInfo;
}

@property (nonatomic, retain) ServiceResponse *serviceResponse;
@property (nonatomic, retain) NSMutableArray *videoSource;
@property (nonatomic, retain) NSMutableArray *newsArray;
@property (nonatomic, retain) NSMutableDictionary *tweetDetails;
@property (nonatomic, retain) NSArray *playlistNamesArray;
@property (nonatomic, retain) NSMutableDictionary *playlistIdDict; 
@property (nonatomic, retain) NSMutableArray *picsArray;
@property (nonatomic, retain) id<TTPhotoSource> photoSource;
@property (nonatomic, retain) NSMutableArray *twitterArray;
@property (nonatomic, retain) NSMutableDictionary *serviceDownInfo;

#pragma mark singleton object methods 

+ (SharedObjects *)sharedInstance;

- (void) updatePics:(NSMutableDictionary*) picsDict;
- (void) updateNews:(NSMutableDictionary*) newsDict;
- (void) updateVideos:(NSMutableDictionary*) videosResponseDict;

@end
