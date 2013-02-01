//
//  TwitterUtil.h
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 19/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SA_OAuthTwitterController.h"

@class SA_OAuthTwitterEngine;

@interface TwitterUtil : NSObject
{
    SA_OAuthTwitterEngine *_engine;
}

@property(nonatomic,retain) SA_OAuthTwitterEngine *_engine;

-(void)updateTweets:(NSString*)tweet;

-(void)loginToTwitter;

@end
