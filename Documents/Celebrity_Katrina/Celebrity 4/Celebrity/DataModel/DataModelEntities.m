//
//  DataModelEntities.m
//
//  Created by Admin on 11/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataModelEntities.h"
#import "SharedObjects.h"
#import "DictionaryUtils.h"
//#import "TwitterTableItem.h"

@implementation ServiceResponse

//@synthesize twitterResponse;

- (id)init {
	self = [super init];
	
	if (self) {
//		if(nil == twitterResponse)
//        {
//            twitterResponse = [[NSMutableArray alloc] init];
//        }
	}
	return self;
}

/*
-(void) setTwitterProperties:(NSMutableArray*) array
{
    DictionaryUtils *dictUtils = [DictionaryUtils sharedInstance];
    
    if(nil != array)
    {
        for(int i = 0; i< [array count];i++)
        {
            TwitterTableItem *item = [TwitterTableItem itemWithTweet:[[array objectAtIndex:i] objectForKey:@"text"] 
                                                     timestamp:[[array objectAtIndex:i] objectForKey:@"created_at"] 
                                               profileImageURL:[NSString stringWithFormat:@"%@",[[[array objectAtIndex:i] objectForKey:@"user"]
                                                                                                 objectForKey:@"profile_image_url"]] 
                                                       tweetId:[[array objectAtIndex:i] objectForKey:@"id_str"] 
                                                      username:[[[array objectAtIndex:i] objectForKey:@"user"] objectForKey:@"screen_name"]];
            
            [[[SharedObjects sharedInstance] twitterArray] addObject:item];

            if ([dictUtils dict:[array objectAtIndex:i] hasKey:@"retweeted_status"]) {
              
                NSDictionary *tempDict = (NSDictionary*) [[array objectAtIndex:i] objectForKey:@"retweeted_status"];
                
                TwitterTableItem *item = [TwitterTableItem itemWithTweet:[tempDict objectForKey:@"text"] 
                                                         timestamp:[tempDict objectForKey:@"created_at"] 
                                                   profileImageURL:[NSString stringWithFormat:@"%@", [[tempDict                                                            objectForKey:@"user"] objectForKey:@"profile_image_url"]] 
                                                           tweetId:[tempDict objectForKey:@"id_str"] 
                                                          username:[[tempDict objectForKey:@"user"] objectForKey:@"screen_name"]];
                
                [[[SharedObjects sharedInstance] twitterArray] addObject:item];
            }
        }
    }
}
*/

-(void) dealloc
{	
//    if(nil != twitterResponse)
//    {
//        [twitterResponse release];
//        twitterResponse = nil;
//    }
    
	[super dealloc];
}

@end

