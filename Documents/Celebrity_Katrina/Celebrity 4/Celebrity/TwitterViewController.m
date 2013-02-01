//
//  TwitterViewController.m
//  Twitter
//
//  Created by chandramouli shivakumar on 2/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterViewController.h"
#import "ServiceHandler.h"
#import "SharedObjects.h"
#import "Constants.h"
#import "DataModelEntities.h"
#import "CelebrityAppDelegate.h"
#import "TwtDataSource.h"
#import "TwitterItemCell.h"
#import "RootViewController.h"
#import "DictionaryUtils.h"

@implementation TwitterViewController

@synthesize adBanner = adBanner_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTweetNotification:) 
                                                     name:IFTweetLabelURLNotification object:nil];

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

- (void) loadView {

    UIView *ContentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.view = ContentView;
	[ContentView release];
	self.view.opaque = YES;
    
    CGRect reloadButtonFrame = CGRectZero;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tweets_title.png"] 
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    UIImageView *backgroundTwitter = [[UIImageView alloc] init];
    backgroundTwitter.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    backgroundTwitter.image = [UIImage imageNamed:@"background.png"];

    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        [self.tableView setFrame:CGRectMake(0, 77, [[UIScreen mainScreen] bounds].size.width, 
                                            [[UIScreen mainScreen] bounds].size.height-60-
                                            CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height)];
        reloadButtonFrame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 117, 10, 47, 47);
    }
    else {
        [self.tableView setFrame:CGRectMake(0, 44, [[UIScreen mainScreen] bounds].size.width, 
                                            [[UIScreen mainScreen] bounds].size.height-45-
                                            CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height)];
        reloadButtonFrame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 70, 5, 30, 30);
    }
    [self.view insertSubview:backgroundTwitter belowSubview:self.tableView];

    [backgroundTwitter release];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    ///////////////// AdMob Integration ///////////////////
    
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*) [[UIApplication sharedApplication] delegate];
    
    // Initialize the banner at the bottom of the screen.
    CGPoint origin = CGPointMake(0.0, self.tableView.frame.size.height+
                                 CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height/2);
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.adBanner = [[[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait 
                                                    origin:origin] autorelease];
    
    self.adBanner.adUnitID = INTERSTITIAL_AD_UNIT_ID;
    self.adBanner.delegate = [delegate rootViewController];
    [self.adBanner setRootViewController:[delegate rootViewController]];
    
    [self.adBanner loadRequest:[[DictionaryUtils sharedInstance] createRequest]];
    [self.tableView setTableFooterView:[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease]];
    [self.view addSubview:self.adBanner];

    self.variableHeightRows = YES;

    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadButton setFrame:reloadButtonFrame];
    [reloadButton addTarget:self action:@selector(refreshTwits) forControlEvents:UIControlEventTouchUpInside];
    [reloadButton setBackgroundImage:[UIImage imageNamed:@"refresh_normal.png"] forState:UIControlStateNormal];
    [reloadButton setBackgroundImage:[UIImage imageNamed:@"refresh_clicked.png"] forState:UIControlStateHighlighted];
    [self.navigationController.navigationBar addSubview:reloadButton];

    self.dataSource = [TwtDataSource twitterDataSource];
}

- (void) refreshTwits {

    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*)[[UIApplication sharedApplication] delegate];

    if ([delegate isNetworkAvailable]) {
        
        [[delegate rootViewController] addLoadingView];
        
        ServiceHandler *serviceHandler = [[ServiceHandler alloc] init];
        
        [serviceHandler twitterService:self :@selector(twitterResponseObtained:)];
        
        [serviceHandler release];
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

-(void) twitterResponseObtained:(NSMutableArray*) twitterResponse
{
    ServiceResponse *serviceResponse = [SharedObjects sharedInstance].serviceResponse;
    
    [serviceResponse setTwitterProperties:twitterResponse];
    
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*)[[UIApplication sharedApplication] delegate];

    [[delegate rootViewController] removeLoadingView];
}

- (void)handleTweetNotification:(NSNotification *)notification
{
    if (nil != webController) {
        [webController release];
    }
    
    webController = [[TwitterWebController alloc] init];

    [webController setHeaderView:[[[UIView alloc] init] autorelease]];
    
    [webController openURL:[NSURL URLWithString:notification.object]];
    
    // Push the controller to the navigation controller stack
    [self.navigationController pushViewController:webController animated:YES];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IFTweetLabelURLNotification object:nil];
    TT_RELEASE_SAFELY(webController);
    adBanner_.delegate = nil;
    [adBanner_ release];
    [super dealloc];
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

@end
