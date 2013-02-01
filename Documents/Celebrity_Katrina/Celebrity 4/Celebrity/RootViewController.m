//
//  RootViewController.m
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 12/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "GADAdMobExtras.h"
#import "DictionaryUtils.h"
#import "SharedObjects.h"
#import "DataModelEntities.h"
#import "Constants.h"
#import "CelebrityAppDelegate.h"
#import "AlertPrompt.h"

@implementation RootViewController

@synthesize adBanner = adBanner_;
@synthesize selectedController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        /*share to Facebook Notification*/
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareLinkInFacebook:) 
                                                     name:kFaceBookShareNotification object:nil];
        
        /*share to Twitter Notification*/
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareLinkInTwitter:) 
                                                     name:kTwitterShareNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyToTweet:) 
                                                     name:kreplyTweetNotification object:nil];

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    /*Used for Downloading Large content files*/
    [[TTURLRequestQueue mainQueue] setMaxContentLength:0];
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];

    initialView = [[UIView alloc] initWithFrame:screenRect];
    
    UIImageView *bg = [[UIImageView alloc] init];
    bg.frame = CGRectMake(0, -20, [[UIScreen mainScreen] bounds].size.width, //20
                          [[UIScreen mainScreen] bounds].size.height);
    
    UIButton *photos = [[UIButton alloc] init];
    UIButton *video = [[UIButton alloc] init];
    UIButton *news = [[UIButton alloc] init];
    UIButton *puzzle = [[UIButton alloc] init];
    //UIButton *heart = [[UIButton alloc] init];
    
    UIImageView *buttonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbarBg.png"]];
    
    [photos setBackgroundImage:[UIImage imageNamed:@"Picture.png"] forState:UIControlStateNormal];
    [video setBackgroundImage:[UIImage imageNamed:@"Video.png"] forState:UIControlStateNormal];
    [news setBackgroundImage:[UIImage imageNamed:@"News.png"] forState:UIControlStateNormal];
    [puzzle setBackgroundImage:[UIImage imageNamed:@"Tweets.png"] forState:UIControlStateNormal];
    //[heart setBackgroundImage:[UIImage imageNamed:@"Video.png"] forState:UIControlStateNormal];
    
    bg.image = [UIImage imageNamed:@"bg_home.png"];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        photos.frame = CGRectMake(55, 840, 135, 160);
        video.frame = CGRectMake(photos.frame.origin.x+photos.frame.size.width+37, photos.frame.origin.y, 
                                 photos.frame.size.width, photos.frame.size.height);
        news.frame = CGRectMake(video.frame.origin.x+video.frame.size.width+37, photos.frame.origin.y, 
                                photos.frame.size.width, photos.frame.size.height);
        puzzle.frame = CGRectMake(news.frame.origin.x+news.frame.size.width+37, photos.frame.origin.y, 
                                      photos.frame.size.width, photos.frame.size.height);
        buttonView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-72, 
                                      [[UIScreen mainScreen] bounds].size.width, 72);
        
        //heart.frame = CGRectMake(100, 400, 135, 160);
    }
    else
    {
        photos.frame = CGRectMake(16, 360, 65, 76);
        video.frame = CGRectMake(photos.frame.origin.x+photos.frame.size.width+10, photos.frame.origin.y, 
                                 photos.frame.size.width, photos.frame.size.height);
        news.frame = CGRectMake(video.frame.origin.x+video.frame.size.width+10, photos.frame.origin.y, 
                                photos.frame.size.width, photos.frame.size.height);
        puzzle.frame = CGRectMake(news.frame.origin.x+news.frame.size.width+10, photos.frame.origin.y, 
                                      photos.frame.size.width, photos.frame.size.height);
        buttonView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-50-20, 
                                      [[UIScreen mainScreen] bounds].size.width, 50);
        
        //heart.frame = CGRectMake(40, 200, 65, 76);
    }
    
    [initialView addSubview:bg];
    [bg addSubview:buttonView];
    
    [buttonView release];
    [bg release];
    
    [photos addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    photos.tag = 1;
    // add to a view
    [initialView addSubview:photos];
    
    
    // add targets and actions
    [news addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    news.tag = 2;
    // add to a view
    [initialView addSubview:news];
    
    
    // add targets and actions
    [video addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    video.tag = 3;
    // add to a view
    [initialView addSubview:video];
    
    
    // add targets and actions
    [puzzle addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    puzzle.tag = 4;
    // add to a view
    [initialView addSubview:puzzle];
    
    
    // add targets and actions
//    [heart addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    heart.tag = 5;
//    // add to a view
//    [initialView addSubview:heart];
    
    
    /*Release All Buttons*/
    [photos release];
    [video release];
    [puzzle release];
    [news release];
//    [heart release];
    
    ///////////////// AdMob Integration ///////////////////
    // Initialize the banner at the bottom of the screen.
    //    CGPoint origin = CGPointMake(0.0, 0.0);
    //    self.view.frame.size.height -
    //    CGSizeFromGADAdSize(kGADAdSizeBanner).height
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.adBanner = [[[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait 
                                                    origin:CGPointMake(0, -20)] autorelease];
    
    self.adBanner.adUnitID = INTERSTITIAL_AD_UNIT_ID;
    self.adBanner.delegate = self;
    [self.adBanner setRootViewController:self];
    [initialView addSubview:self.adBanner];
    [initialView bringSubviewToFront:self.adBanner];
    
    [self.adBanner loadRequest:[[DictionaryUtils sharedInstance] createRequest]];

    [self.view addSubview:initialView];
    [initialView release];
}

-(void)buttonClicked:(id)sender {
    
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*) [[UIApplication sharedApplication] delegate];
    
    if ([delegate isNetworkAvailable]) {
        
        UIButton *button = (UIButton*)sender;
        switch (button.tag) {
            case 1:
            {
                AlbumController *tempAlbumController = [[AlbumController alloc] init];  
                selectedController = [[UINavigationController alloc] initWithRootViewController:tempAlbumController];
                [tempAlbumController release];
                
                UIView *loadingView = [[DictionaryUtils sharedInstance] loadingViewOnNativePages];
                [loadingView setTag:kLoadingIndicatorOnNativePages];
                [self.view addSubview:loadingView];
                
                ServiceHandler *service = [[ServiceHandler alloc] init];
                [service callService:self :@selector(getPhotoInfo) :kPhoto];
                [service release];
            }
                break;
            case 2:
            {
                News *tempNewsView = [[News alloc] init];
                selectedController = [[UINavigationController alloc] initWithRootViewController:tempNewsView];
                [tempNewsView release];
                
                UIView *loadingView = [[DictionaryUtils sharedInstance] loadingViewOnNativePages];
                [loadingView setTag:kLoadingIndicatorOnNativePages];
                [self.view addSubview:loadingView];
                
                ServiceHandler *service = [[ServiceHandler alloc] init];
                [service callService:self :@selector(getNewsInfo) :kNews];
                [service release];
            }
                break;
            case 3:
            {
                VideosViewController *tempVideosView = [[VideosViewController alloc] init];
                selectedController = [[UINavigationController alloc] initWithRootViewController:tempVideosView];
                [tempVideosView release];
                
                [self showView];
            }
                break;
            case 4:
            {
                DragDropViewController *tempDragView = [[DragDropViewController alloc] init];
                selectedController = [[UINavigationController alloc] initWithRootViewController:tempDragView];
                [tempDragView release];
                
                [self showView];
            }
                break;
            default:
                break;
        }
    }
    else {
        
        // no network message
        UIAlertView *networkAlert1 = [[UIAlertView alloc] initWithTitle:nil 
                                                                message:kNoNetworkErr 
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles:nil];
        
        [networkAlert1 show];
        
        [networkAlert1 release];
    }
}

-(void)getNewsInfo {
	
    [self removeLoader];
    
    [self showView];
}

-(void) twitterResponseObtained:(NSMutableArray*) twitterResponse
{
    ServiceResponse *serviceResponse = [SharedObjects sharedInstance].serviceResponse;
    
    [serviceResponse setTwitterProperties:twitterResponse];
    
    [self removeLoader];
    
    [self showView];
}

- (void) removeLoader {
    
    for (UIView *view in [self.view subviews]) {
        
        if (view.tag == kLoadingIndicatorOnNativePages) {
            
            if (nil != view)
            {
                [view removeFromSuperview];
                
                [self enableTouch];
            }
        }
    }
}

- (void) enableTouch {
    
    for (UIView *view in [self.view subviews]) {
        
        [view setUserInteractionEnabled:YES];
    }
} 

- (void) getPhotoInfo {
	
    [self removeLoader];
    
    [self showView];
}

-(void) showView {
    
    // set frame
    selectedController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    CGRect homeButtonFrame = CGRectZero;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        homeButtonFrame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 55, 10, 47, 47);
    }
    else {
        homeButtonFrame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 35, 5, 30, 30);
    }
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeButton setFrame:homeButtonFrame];
    [homeButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [homeButton setBackgroundImage:[UIImage imageNamed:@"home_normal.png"] forState:UIControlStateNormal];
    [homeButton setBackgroundImage:[UIImage imageNamed:@"home_clicked.png"] forState:UIControlStateHighlighted];
    [selectedController.navigationBar addSubview:homeButton];
    
    [self.view addSubview:selectedController.view];
    
}

- (void) dismissView {
    
    if (nil != selectedController.view) {
        
        [selectedController.view removeFromSuperview];
        
        [selectedController release];
        selectedController = nil;
    }
}

- (void) replyToTweet:(NSNotification*)notification {
    
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*) [[UIApplication sharedApplication] delegate];
    
    if(![[delegate _engine] isAuthorized]){  
        
        [self loginToTwitter]; 
    }
    else{
        
        // show custom alert prompting user entry
        
        AlertPrompt *prompt = [AlertPrompt alloc];
        prompt = [prompt initWithTitle:@"Twitter" 
                               message:@"Please enter some text in\n\n\n\n" 
                              delegate:self 
                     cancelButtonTitle:@"Cancel" 
                         okButtonTitle:@"Okay"];
        [prompt show];
        prompt.frame = CGRectMake(20, 45, 315, 230);
        [prompt release];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*) [[UIApplication sharedApplication] delegate];
    
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        [self addLoadingView];
        
        NSString *entered = [(AlertPrompt *)alertView enteredText];
        
        [[delegate _engine] sendUpdate:[NSString stringWithFormat:@"%@ %@", 
                             [[[SharedObjects sharedInstance] tweetDetails] objectForKey:@"tweetUser"], entered] 
                  inReplyTo:[[[[SharedObjects sharedInstance] tweetDetails] objectForKey:@"tweetId"] longLongValue]];
    }
}

#pragma 
#pragma Share methods
#pragma 

-(void)shareLinkInFacebook:(NSNotification*)notification {
    
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*) [[UIApplication sharedApplication] delegate];

    if ([delegate isNetworkAvailable]) {
        
        if (![delegate.fbUtil.facebook isSessionValid]) {
            
            [delegate.fbUtil login];
        }
        else {
            
            // add loading indicator
            [self addLoadingView];
            
            if (nil != notification.object) {
                
                if ([notification.object isKindOfClass:[UIButton class]]) {
                    
                    UIButton *temp = (UIButton*) [notification object];
                    
                    if (temp.tag == kVideoShareTag || temp.tag == kNewsShareTag) {
                        
                        [delegate.fbUtil shareNewsAndVideo:(NSMutableDictionary*)[notification userInfo]];
                    }
                }
                else if ([notification.object isKindOfClass:[NSString class]]) {
                    
                    NSString *url = notification.object;
                    
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                    
                    UIImage *image = [UIImage imageWithData:data];
                    
                    NSMutableDictionary *shareDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"Pic shared from %@ Mobile app",kAppName], @"name",
                                                      image, @"picture",
                                                      nil];
                    
                    [delegate.fbUtil postPhotoToWall:shareDict];
                    
                }
            }
        }
    }
    else {
        
        // no network message
        UIAlertView *networkAlert1 = [[UIAlertView alloc] initWithTitle:nil 
                                                                message:kNoNetworkErr 
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles:nil];
        
        [networkAlert1 show];
        
        [networkAlert1 release];
    }
}

-(void)shareLinkInTwitter:(NSNotification*)notification{
    
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*) [[UIApplication sharedApplication] delegate];

    if ([delegate isNetworkAvailable]) {
        
        if(![[delegate _engine] isAuthorized]){  
            
            [self loginToTwitter]; 
        }
        else {
            
            // add loading indicator
            [self addLoadingView];
            
            if (nil != notification.object) {
                
                if ([notification.object isKindOfClass:[UIButton class]]) {
                    
                    UIButton *temp = (UIButton*) [notification object];
                    
                    if (temp.tag == kVideoTweetTag || temp.tag == kNewsTweetTag) {
                        
                        NSString *videoShareString = [NSString stringWithFormat:@"%@ %@", [[notification userInfo] objectForKey:@"caption"],
                                                      [[notification userInfo] objectForKey:@"link"]];
                        
                        [[delegate _engine] sendUpdate:videoShareString];
                    }
                    else if (temp.tag == kRetweetTag) {
                        
                        NSString *tweetString = [NSString stringWithFormat:@"%@", [[notification userInfo] objectForKey:@"tweetId"]];
                        
                        [[delegate _engine] sendRetweet:tweetString];
                    }
                }
                else if ([notification.object isKindOfClass:[NSString class]]) {
                    
                    NSString *url = notification.object;
                    
                    NSData *imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                    
                    UIImage *image = [UIImage imageWithData:imageData1];
                    
                    NSURL *serviceURL = [NSURL URLWithString:@"https://api.twitter.com/1/account/verify_credentials.json"];
                    
                    OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:serviceURL
                                                                                    consumer:[[delegate _engine] consumer]
                                                                                       token:[[delegate _engine] getAccessToken]
                                                                                       realm:@"http://api.twitter.com/"
                                                                           signatureProvider:[[delegate _engine] signatureProvider]];
                    [oRequest setHTTPMethod:@"GET"];
                    
                    [oRequest prepare];
                    
                    NSDictionary * headerDict = [oRequest allHTTPHeaderFields];
                    NSString * oauthHeader = [NSString stringWithString:[headerDict valueForKey:@"Authorization"]];
                    
                    [oRequest release];
                    oRequest = nil;
                    
                    serviceURL = [NSURL URLWithString:@"http://img.ly/api/2/upload.xml"];
                    oRequest = [[OAMutableURLRequest alloc] initWithURL:serviceURL
                                                               consumer:[[delegate _engine] consumer]
                                                                  token:[[delegate _engine] getAccessToken]
                                                                  realm:@"http://api.twitter.com/"
                                                      signatureProvider:[[delegate _engine] signatureProvider]];
                    [oRequest setHTTPMethod:@"POST"];
                    [oRequest setValue:@"https://api.twitter.com/1/account/verify_credentials.json" 
                    forHTTPHeaderField:@"X-Auth-Service-Provider"];
                    
                    [oRequest setValue:oauthHeader forHTTPHeaderField:@"X-Verify-Credentials-Authorization"];
                    
                    
                    CGFloat compression = 0.9f;
                    NSData *imageData = UIImageJPEGRepresentation(image, compression);
                    
                    // TODO
                    // Note from Nate to creator of sendImage method - This seems like it could be a source of sluggishness.
                    // For example, if the image is large (say 3000px x 3000px for example), it would be better to resize the image
                    // to an appropriate size (max of img.ly) and then start trying to compress.
                    
                    while ([imageData length] > 700000 && compression > 0.1) {
                        // NSLog(@"Image size too big, compression more: current data size: %d bytes",[imageData length]);
                        compression -= 0.1;
                        imageData = UIImageJPEGRepresentation(image, compression);
                        
                    }
                    
                    NSString *boundary = @"0xKhTmLbOuNdArY";
                    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
                    [oRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
                    
                    NSMutableData *body = [NSMutableData data];
                    NSString *dispKey = @"Content-Disposition: form-data; name=\"media\"; filename=\"upload.jpg\"\r\n";;
                    
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[dispKey dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:imageData];
                    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    //[body appendData:[[params objectForKey:@"caption"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];	
                    
                    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    // setting the body of the post to the reqeust
                    [oRequest setHTTPBody:body];
                    
                    // Start the request
                    OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
                                                                                                          delegate:self
                                                                                                 didFinishSelector:@selector(sendImageTicket:didFinishWithData:)
                                                                                                   didFailSelector:@selector(sendImageTicket:didFailWithError:)];	
                    [fetcher start];
                    
                    [oRequest release];
                }
            }
        }
    }
    else {
        
        // no network message
        UIAlertView *networkAlert1 = [[UIAlertView alloc] initWithTitle:nil 
                                                                message:kNoNetworkErr 
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles:nil];
        
        [networkAlert1 show];
        
        [networkAlert1 release];
    }
}

- (void)sendImageTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	// TODO better error handling here
	
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*) [[UIApplication sharedApplication] delegate];

	if (ticket.didSucceed) {
		//[self sendDidFinish];
		// Finished uploading Image, now need to posh the message and url in twitter
		NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		NSRange startingRange = [dataString rangeOfString:@"<url>" options:NSCaseInsensitiveSearch];
		NSRange endingRange = [dataString rangeOfString:@"</url>" options:NSCaseInsensitiveSearch];
		
		if (startingRange.location != NSNotFound && endingRange.location != NSNotFound) {
			NSString *urlString = [dataString substringWithRange:NSMakeRange(startingRange.location + startingRange.length, endingRange.location - (startingRange.location + startingRange.length))];
			
            [[delegate _engine] sendUpdate:[NSString stringWithFormat:@"Shared from %@ Mobile app %@", kAppName, urlString]];
		}
	} 
    else {
		
        [self sendImageTicket:ticket didFailWithError:nil];
	}
}

- (void)sendImageTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error {
	
    UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:nil 
                                                     message:@"Tweet failed" 
                                                    delegate:nil
                                           cancelButtonTitle:@"Ok" 
                                           otherButtonTitles:nil];
    [alert3 show];
    [alert3 release];
}

-(void)loginToTwitter{
    
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*) [[UIApplication sharedApplication] delegate];

    UIViewController *controller = [SA_OAuthTwitterController 
                                    controllerToEnterCredentialsWithTwitterEngine:[delegate _engine] 
                                    delegate:self];  
    if (controller){  
        
        [[self selectedController] presentModalViewController:controller animated:YES];  
    }  
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate

- (void) requestSucceeded: (NSString *) requestIdentifier {
	
    // remove loading indicator
    [self removeLoadingView];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                    message:@"Tweet successful" 
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	
    // remove loading indicator
    [self removeLoadingView];
    
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:nil 
                                                     message:@"Tweet failed. Please try again" 
                                                    delegate:nil
                                           cancelButtonTitle:@"Ok" 
                                           otherButtonTitles:nil];
    [alert1 show];
    [alert1 release];
    
}

- (void) addLoadingView {
    
    UIView *loadingView = [[DictionaryUtils sharedInstance] loadingViewOnNativePages];
    
    [loadingView setTag:kLoadingIndicatorOnNativePages];
    
    [selectedController.view addSubview:loadingView];
}

- (void) removeLoadingView {
    
    for (UIView *view in [selectedController.view subviews]) {
        
        if (view.tag == kLoadingIndicatorOnNativePages) {
            
            if (nil != view)
            {
                [view removeFromSuperview];
                [self enableUserInteraction];
            }
        }
    }
}

-(void) enableUserInteraction {
	
	for (UIView *view in [selectedController.view subviews]) {
		
        [view setUserInteractionEnabled:YES];
	}
}

#pragma mark GADBannerViewDelegate impl

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    }
    
    return NO;
}

- (void) dealloc {

    if (nil != selectedController) [selectedController release];
    adBanner_.delegate = nil;
    [adBanner_ release];

    [super dealloc];
}

@end
