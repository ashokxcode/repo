//
//  TwitterTableItem.m
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterTableItem.h"

@implementation TwitterTableItem

@synthesize tweet = _tweet;
@synthesize profileImage = _profileImage;
@synthesize timeStamp = _timeStamp;
@synthesize tweetId = _tweetId;
@synthesize username = _username;

- (id)init {  
    if (self = [super init]) {  
        _profileImage = nil;
    }  
    return self;  
}  

+ (id)itemWithTweet:(NSString*)text 
          timestamp:(NSString*)time 
    profileImageURL:(NSString*)imageURL
            tweetId:(NSString*)tweetId
           username:(NSString*)username {
    
    TwitterTableItem* item = [[[self alloc] init] autorelease];
    item.tweet = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    item.timeStamp = time;
    item.profileImage = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    item.tweetId = tweetId;
    item.username = username;
    
    return item;
}

-(void) dealloc
{	
    [_tweet release];
    [_profileImage release];
    [_timeStamp release];
    [_tweetId release];
    [_username release];
	[super dealloc];
}

@end

