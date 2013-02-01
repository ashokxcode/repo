//
//  Videos.m
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 13/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Videos.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoDataSource.h"
#import "Constants.h"
#import "CelebrityAppDelegate.h"
#import "RootViewController.h"
#import "DictionaryUtils.h"

@implementation Videos

@synthesize selectedVideoItem;
@synthesize adBanner = adBanner_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
      
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(shareThis:) 
                                                     name:kshareVideoNotification 
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(tweetThis:) 
                                                     name:ktweetVideoNotification 
                                                   object:nil];
    }
    return self;
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
    [super loadView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"videos_title.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem setHidesBackButton:YES];

    [self.navigationController.navigationBar setTranslucent:YES];

    // Set the custom back button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 189;
    [button setBackgroundImage:[UIImage imageNamed:@"back_normal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"back_clicked.png"] forState:UIControlStateHighlighted];	     
    //set the frame of the button to the size of the image (see note below)
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        button.frame = CGRectMake(15, 10, 47, 47);
    }
    else {
        button.frame = CGRectMake(10, 5, 30, 30);
    }
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:button];
    
    self.variableHeightRows = YES;
    
    CGPoint origin = CGPointZero;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.tableView setFrame:CGRectMake(0, 77, [[UIScreen mainScreen] bounds].size.width, 
                                            [[UIScreen mainScreen] bounds].size.height-115-
                                            CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height)];
        origin = CGPointMake(0.0, self.tableView.frame.size.height+10+
                             CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height);
    }
    else {
        [self.tableView setFrame:CGRectMake(0, 44, [[UIScreen mainScreen] bounds].size.width, 
                                            [[UIScreen mainScreen] bounds].size.height-105-
                                            CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height)];
        origin = CGPointMake(0.0, self.tableView.frame.size.height+40+
                             CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height);
    }
    
    UIImageView *backgroundTwitter = [[UIImageView alloc] init];
    backgroundTwitter.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    backgroundTwitter.image = [UIImage imageNamed:@"background.png"];
    [self.view insertSubview:backgroundTwitter belowSubview:self.tableView];
    [backgroundTwitter release];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    ///////////////// AdMob Integration ///////////////////
    
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*) [[UIApplication sharedApplication] delegate];
    
    // Initialize the banner at the bottom of the screen.
        
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.adBanner = [[[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait 
                                                    origin:origin] autorelease];
    self.adBanner.adUnitID = INTERSTITIAL_AD_UNIT_ID;
    self.adBanner.delegate = [delegate rootViewController];
    [self.adBanner setRootViewController:[delegate rootViewController]];
    
    [self.adBanner loadRequest:[[DictionaryUtils sharedInstance] createRequest]];
    [self.tableView setTableFooterView:[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease]];
    [self.view addSubview:self.adBanner];
}

- (void) back {  
    
    if ([self.navigationController.navigationBar viewWithTag:189]) {
        [[self.navigationController.navigationBar viewWithTag:189] removeFromSuperview];
    }
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) shareThis:(NSNotification*) notification {
    
    self.selectedVideoItem = [[notification userInfo] objectForKey:kNotificationShareKey];
    
    UIButton *button = (UIButton*)[notification object];
    
    if ([selectedVideoItem url] != nil && [[selectedVideoItem url] length] > 0) {
        
        NSArray *array = [[selectedVideoItem url] componentsSeparatedByString:@"watch?v="];
        
        NSString *videoId = (NSString*)[[[array objectAtIndex:1] componentsSeparatedByString:@"&"] objectAtIndex:0];
        
        NSString *sourceUrl = (NSString*)[NSString stringWithFormat:@"%@v/%@",[array objectAtIndex:0],videoId];
        
        if (nil != [selectedVideoItem thumbImageUrl] && [[selectedVideoItem thumbImageUrl] length] > 0) {
            
            NSMutableDictionary *shareParamsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                    [selectedVideoItem url], @"link",
                                                    @"video", @"contentType",
                                                    sourceUrl, @"source",
                                                    [selectedVideoItem thumbImageUrl], @"picture",
                               [NSString stringWithFormat:@"Shared from %@ Mobile app - Videos", kAppName], @"title",
                                                    [selectedVideoItem title], @"description",
                                                    nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kFaceBookShareNotification 
                                                                object:button userInfo:shareParamsDict];
        }
    }
}

- (void) tweetThis:(NSNotification*) notification {
    
    self.selectedVideoItem = [[notification userInfo] objectForKey:kNotificationShareKey];
    
    UIButton *button = (UIButton*)[notification object];
    
    NSMutableDictionary *shareParamsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            [selectedVideoItem url], @"link", 
                                            [selectedVideoItem title], @"caption",
                                            nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTwitterShareNotification 
                                                        object:button userInfo:shareParamsDict];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

    if (nil != selectedVideoItem) [selectedVideoItem release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kshareVideoNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ktweetVideoNotification object:nil];
    adBanner_.delegate = nil;
    [adBanner_ release];
    [super dealloc];
}

@end
