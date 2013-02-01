//
//  SharedObjects.m
//  iShop3.0
//
//  Created by Admin on 11/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SharedObjects.h"
#import "DataModelEntities.h"
#import "DictionaryUtils.h"
#import "TableSubTitleItem.h"
#import "Constants.h"
#import "Photo.h"
#import "PhotoSource.h"

static SharedObjects *shardObjectsDelegate = nil;

@implementation SharedObjects
@synthesize serviceResponse;
@synthesize videoSource;
@synthesize newsArray;
@synthesize tweetDetails;
@synthesize playlistNamesArray;
@synthesize playlistIdDict;
@synthesize picsArray;
@synthesize photoSource;
@synthesize twitterArray;
@synthesize serviceDownInfo;

- (id) init {
	self = [super init];	

    if(nil == serviceResponse)
    {
        serviceResponse = [[ServiceResponse alloc] init];
    }
    if(nil == videoSource) {
        
        videoSource = [[NSMutableArray alloc] init];
    }
    if(nil == newsArray) {
        
        newsArray = [[NSMutableArray alloc] init];
    }
    if (nil == tweetDetails) {
        
        tweetDetails = [[NSMutableDictionary alloc] init];
    }
    if (nil == playlistNamesArray) {
        
        playlistNamesArray = [[NSArray alloc] initWithObjects:[TTTableTextItem itemWithText:@"Katrina Songs"],
                              [TTTableTextItem itemWithText:@"Katrina Memorable Scenes"],
                              nil];
    }
    if (nil == playlistIdDict) {
        
        playlistIdDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"wn8iIV5WUKsabUzHgPI_tgmoxTjDrRTN",
                          @"Katrina Memorable Scenes",  
                          @"wn8iIV5WUKvHiXCYJgoTwTJTQgZCnYf7", @"Katrina Songs", 
                          nil];
    }
    if(nil == twitterArray)
    {
        twitterArray = [[NSMutableArray alloc] init];
    }

    picsArray = [[NSMutableArray alloc] init];
    
    photoSource = nil;

	return self;
}

- (id)autorelease
{
    return self;
}

#pragma mark --
#pragma mark singleton object methods 
#pragma mark --

+ (SharedObjects *)sharedInstance {
    @synchronized(self) {
        if (shardObjectsDelegate == nil) 
		{
			shardObjectsDelegate= [[self alloc] init]; // assignment not done here
        }
    }
	
    return shardObjectsDelegate;
}

- (void) updatePics:(NSMutableDictionary*) picsDict {
    
    if (nil != self.picsArray) {
        
        if ([self.picsArray count] > 0) {
            
            [self.picsArray removeAllObjects];
        }
    }
    
    Photo *photo = nil;
    
    DictionaryUtils *dictUtils = [DictionaryUtils sharedInstance];
    
    if (nil != picsDict) {
        
        if ([dictUtils dict:picsDict hasKey:kimages]) {
            
            NSArray *imgArray = [picsDict objectForKey:kimages];
            
            if (nil != imgArray) {
                
                if ([imgArray count] > 0) {
                    
                    for (int i = 0; i < [imgArray count]; i++) {
                        
                        NSDictionary *picDict = [imgArray objectAtIndex:i];
                        
                        if ([dictUtils dict:picDict hasKey:kThumbnail]) {
                            
                            photo = [[Photo alloc] initWithCaption:[picDict objectForKey:kTitle] 
                                                          urlLarge:[picDict objectForKey:kOriginal] 
                                                          urlThumb:[picDict objectForKey:kThumbnail]
                                                              size:CGSizeMake(0, 440)];
                        }
                        else {
                            
                            photo = [[Photo alloc] initWithCaption:[picDict objectForKey:kTitle] 
                                                          urlLarge:[picDict objectForKey:kOriginal] 
                                                          urlThumb:[picDict objectForKey:kThumbnailUrl]
                                                              size:CGSizeMake(0, 440)];
                        }
                        
                        [self.picsArray addObject:photo];
                    }
                    
                    self.photoSource = [PhotoSource samplePhotoSource]; // use this photosource in photoview and albumview
                }
            }
        }  
    }
}

- (void) updateNews:(NSMutableDictionary*) newsDict {
    
    if (nil != self.newsArray) {
        
        if ([self.newsArray count] > 0) {
            
            [self.newsArray removeAllObjects];
        }
    }
    //    For Newsletter check a condition for displaying images,
    //        If is_cron = 1
    //        get image from this key  : news_img_url
    //        or is_cron = 0
    //        get image from this key  : org_news_img_url
    
    DictionaryUtils *dictUtils = [DictionaryUtils sharedInstance];
    
    if (nil != newsDict) {
        
        if ([dictUtils dict:newsDict hasKey:kimages]) {
            
            NSArray *imgArray = [newsDict objectForKey:kimages];
            
            if (nil != imgArray) {
                
                if ([imgArray count] > 0) {
                    
                    for (int i = 0; i < [imgArray count]; i++) {
                        
                        NSDictionary *newsItemDict = [imgArray objectAtIndex:i];
                        
                        //2012-06-15 04:51:40
                        NSMutableString *dateString = nil;
                        NSMutableString *time = nil;
                        
                        if (nil != [newsItemDict objectForKey:@"created"]) {
                            dateString = [newsItemDict objectForKey:@"created"]; 
                            time = [[dateString componentsSeparatedByString:@" "] objectAtIndex:1];
                        }
                        else {
                            dateString = [NSMutableString stringWithString:@""];
                            time = [NSMutableString stringWithString:@""];
                        }
                        
                        // check for cron
                        if ([[newsItemDict objectForKey:kisCron] intValue] == 0) {
                            
                            [self.newsArray addObject:[TableSubTitleItem itemWithText:[newsItemDict objectForKey:knewsTitle] 
                                                                             subtitle:[newsItemDict objectForKey:knewsDesc] 
                                                                             thumbURL:[newsItemDict objectForKey:knewsThumbImageUrl] 
                                                                             imageURL:[newsItemDict objectForKey:knewsDetailImageUrl] 
                                                                                  URL:[newsItemDict objectForKey:kMoreNewsUrl]
                                                                                 time:time
                                                                                 date:dateString]];
                        }
                        else {
                            
                            [self.newsArray addObject:[TableSubTitleItem itemWithText:[newsItemDict objectForKey:knewsTitle] 
                                                                             subtitle:[newsItemDict objectForKey:knewsDesc] 
                                                                             thumbURL:[newsItemDict objectForKey:knewsThumbImageUrl] 
                                                                             imageURL:[newsItemDict objectForKey:knewsImageUrl] 
                                                                                  URL:[newsItemDict objectForKey:kMoreNewsUrl]
                                                                                 time:time
                                                                                 date:dateString]];
                        }
                    }
                }
            }
        }  
    }
}

- (void) updateVideos:(NSMutableDictionary*) videosResponseDict { 
    
    if (nil != videoSource) {
        
        if ([videoSource count] > 0) {
            
            [videoSource removeAllObjects];
        }
    }
    
    DictionaryUtils *dictUtils = [DictionaryUtils sharedInstance];
    
    if (nil != videosResponseDict) {
        
        if ([dictUtils dict:videosResponseDict hasKey:kData]) {
            
            if ([dictUtils dict:[videosResponseDict objectForKey:kData] hasKey:kItems]) {
                
                NSArray *itemArray = [[videosResponseDict objectForKey:kData] objectForKey:kItems];
                
                if (itemArray != nil && [itemArray count] > 0) {
                    
                    for (int i = 0; i < [itemArray count]; i++) {
                        
                        NSDictionary *itemDict = [itemArray objectAtIndex:i];
                        
                        if (nil != itemDict && [itemDict count] > 0) {
                            
                            NSDictionary *videoDict = [itemDict objectForKey:kvideo];
                            
                            if (nil != videoDict && [videoDict count] > 0) {
                                
                                if ([dictUtils dict:videoDict hasKey:kThumbnail]) {
                                    
                                    [videoSource addObject:[TableSubTitleItem itemWithText:[videoDict objectForKey:kTitle] 
                                                                                  subtitle:[videoDict objectForKey:kDesc] 
                                                                                  imageURL:[[videoDict objectForKey:kThumbnail] objectForKey:kSqDefault] 
                                                                                       URL:[[videoDict objectForKey:kPlayer] objectForKey:kDefault]]];
                                }
                                else if ([dictUtils dict:videoDict hasKey:kThumbnailUrl]) {
                                    
                                    [videoSource addObject:[TableSubTitleItem itemWithText:[videoDict objectForKey:kTitle] 
                                                                                  subtitle:[videoDict objectForKey:kDesc] 
                                                                                  imageURL:[[videoDict objectForKey:kThumbnailUrl] objectForKey:kSqDefault] 
                                                                                       URL:[[videoDict objectForKey:kPlayer] objectForKey:kDefault]]];
                                }
                            }
                            
                        }
                        
                    }
                }
                else {
                    
                    // no video elements found
                }
            }
        }
    } 
}

- (void) dealloc
{
    if(nil != serviceResponse)
    {
        [serviceResponse release];
        serviceResponse = nil;
    }
    if(nil != videoSource)
    {
        [videoSource release];
        videoSource = nil;
    }
    if (nil != newsArray) 
    {
        [newsArray release];
        newsArray = nil;
    }
    if (nil != tweetDetails) 
    {
        [tweetDetails release];
        tweetDetails = nil;
    }
    if (nil != playlistIdDict) 
    {
        [playlistIdDict release];
        playlistIdDict = nil;
    }
    if (nil != playlistNamesArray) 
    {
        [playlistNamesArray release];
        playlistNamesArray = nil;
    }
    if(nil != twitterArray)
    {
        [twitterArray release];
        twitterArray = nil;
    }

	[super dealloc];
}

@end
