//
//  Constants.h
//  Twitter
//
//  Created by chandramouli shivakumar on 2/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#define SCREENWIDTH     [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT    [[UIScreen mainScreen] bounds].size.height

#define INTERSTITIAL_AD_UNIT_ID @"a1504f2d0451fcb" // Publisher id --- www.admob.com

#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__) - (__MIN__)))
#define kNumberOfImages 6

#define kOAuthConsumerKey	  @"EFLwhEVQ6j2IyobFw1l8w"		//REPLACE With Twitter App OAuth Key  
#define kOAuthConsumerSecret  @"XnAWSIfToXNJmTyrIhKFubgIzDRxu9FSgX5L7BFB4"		//REPLACE With Twitter App OAuth Secret

#define kAppName     @"KatrinaFanWorld"
#define kAppIconLink @"http://www.x-valuetech.com/katrina/app_icon.png"

#define kshareVideoNotification @"shareVideoNotification"
#define ktweetVideoNotification @"tweetVideoNotification"

#define kshareNewsNotification @"shareNewsNotification"
#define ktweetNewsNotification @"tweetNewsNotification"

#define kFaceBookShareNotification   @"FaceBookShare"
#define kTwitterShareNotification    @"TwitterShare"
#define kreplyTweetNotification      @"replyTweet"

#define kVideoShareTag 152
#define kVideoTweetTag 154
#define kNotificationShareKey @"tableitem"

#define kNewsShareTag 320
#define kNewsTweetTag 309
#define kRetweetTag   301

#define kNoNetworkErr @"This feature requires an Internet connection. Be sure you are connected and try again."

/*Services*/

#define kVideo @"videos"
#define kNews @"newsletter"
#define kPhoto @"photos"

#define kServiceDownMessage @"No Data or Network Connection"

/*Service Data Retreive Key*/

#define kVideoRetreive @"videos"

#define kNewsRetreive @"images"

#define kPhotoRetreive @"images"

/*User Details*/

#define kUserId     @"48"

#define kUserIdKey  @"user_id"

/*Table Height*/
#define kNewsTableCellHeight    90

#define kVideoTableCellHeight   90

/*FaceBook*/
#define _APP_KEY    @"280603118707328"

#define kService_name  @"service_name"
#define kStatus_code   @"status_code"
#define kStatus        @"status"
#define kSuccess_code  @"200"
#define kSuccess       @"success"
#define kMessage       @"message"

#define kData         @"data"
#define kimages       @"images"
#define kTitle        @"title"
#define kOriginal     @"org_url"
#define kThumbnail    @"thumbnail"
#define kThumbnailUrl @"thumbnail_url"
#define kItems      @"items"
#define kDesc       @"description"
#define kSqDefault  @"sqDefault"
#define kDefault    @"default"
#define kPlayer     @"player"
#define kvideo      @"video"

#define kisCron             @"is_cron"
#define knewsTitle          @"news_title"
#define knewsDesc           @"news_desc"
#define knewsImageUrl       @"news_img_url"
#define knewsDetailImageUrl @"org_news_img_url"
#define knewsThumbImageUrl  @"thumb_news_img_url"
#define kMoreNewsUrl        @"more_url"

#define kFontHelvetica13 [UIFont fontWithName:@"Helvetica" size:13]
#define kFontHelveticaBold13 [UIFont fontWithName:@"Helvetica-Bold" size:13]
#define kFontHelvetica14 [UIFont fontWithName:@"Helvetica" size:14]
#define kFontHelveticaBold14 [UIFont fontWithName:@"Helvetica-Bold" size:14]
#define kFontHelvetica15 [UIFont fontWithName:@"Helvetica" size:15]
#define kFontHelveticaBold15 [UIFont fontWithName:@"Helvetica-Bold" size:15]
#define kFontHelvetica16 [UIFont fontWithName:@"Helvetica" size:16]
#define kFontHelveticaBold16 [UIFont fontWithName:@"Helvetica-Bold" size:16]

#define kFontHelvetica20 [UIFont fontWithName:@"Helvetica" size:20]
#define kFontHelveticaBold20 [UIFont fontWithName:@"Helvetica-Bold" size:20]
#define kFontHelvetica22 [UIFont fontWithName:@"Helvetica" size:22]
#define kFontHelveticaBold22 [UIFont fontWithName:@"Helvetica-Bold" size:22]

#define kFontColor       [UIColor blackColor]
#define kSubFontColor    [UIColor blackColor]

