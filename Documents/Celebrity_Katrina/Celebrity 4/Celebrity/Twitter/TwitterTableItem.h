//
//  TwitterTableItem.h
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface TwitterTableItem : TTTableSubtitleItem {
	
    NSString *_tweet;
    NSString *_profileImage;
    NSString *_timeStamp;
    NSString *_tweetId;
    NSString *_username;
}
@property (nonatomic, copy) NSString *tweet;
@property (nonatomic, copy) NSString *profileImage;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *tweetId;
@property (nonatomic, copy) NSString *username;

+ (id)itemWithTweet:(NSString*)text 
          timestamp:(NSString*)time 
    profileImageURL:(NSString*)imageURL
            tweetId:(NSString*)tweetId
           username:(NSString*)username;

@end
