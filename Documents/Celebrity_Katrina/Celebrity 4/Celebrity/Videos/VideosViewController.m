//
//  VideosViewController.m
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideosViewController.h"
#import "VideoDataSource.h"
#import "SharedObjects.h"
#import "CelebrityAppDelegate.h"
#import "RootViewController.h"
#import "Constants.h"
#import "DictionaryUtils.h"

@implementation VideosViewController

@synthesize videos;
@synthesize adBanner = adBanner_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*
- (void)loadView
{
    UIView *ContentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.view = ContentView;
	[ContentView release];
	self.view.opaque = YES;
}*/

- (void) viewDidLoad {

    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"videos_title.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTranslucent:YES];

    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIImageView *backgroundTwitter = [[UIImageView alloc] init];
    backgroundTwitter.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 
                                         [[UIScreen mainScreen] bounds].size.height);
    backgroundTwitter.image = [UIImage imageNamed:@"background.png"];
    
    CGPoint origin = CGPointZero;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        [self.tableView setFrame:CGRectMake(0, 77, [[UIScreen mainScreen] bounds].size.width, 
                                            [[UIScreen mainScreen] bounds].size.height-115-
                                            CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height/2)];
        origin = CGPointMake(0.0, self.tableView.frame.size.height+10+
                             CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height/2);
    }
    else {
        [self.tableView setFrame:CGRectMake(0, 44, [[UIScreen mainScreen] bounds].size.width, 
                                            [[UIScreen mainScreen] bounds].size.height-105-
                                            CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height/2)];
        origin = CGPointMake(0.0, self.tableView.frame.size.height+10+
                                      CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height);
    }
    
    [self.view insertSubview:backgroundTwitter belowSubview:self.tableView];
    [backgroundTwitter release];
    
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
    
    self.dataSource = [VideoDataSource playListDataSource];
    
    self.variableHeightRows = YES;
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (nil != videos) {
        [videos release];
    }
    
    videos = [[Videos alloc] init];
    
    NSString *playlistId = [[[SharedObjects sharedInstance] playlistIdDict] objectForKey:[object text]];
    
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*)[[UIApplication sharedApplication] delegate];

    [[delegate rootViewController] addLoadingView];
    
    ServiceHandler *serviceHandler = [[ServiceHandler alloc] init];

    [serviceHandler callVideosService:self :@selector(videoServiceDone) :playlistId];
    
    [serviceHandler release];
}

- (void) videoServiceDone {
    
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*)[[UIApplication sharedApplication] delegate];

    [[delegate rootViewController] removeLoadingView];
    
    videos.dataSource = [VideoDataSource rootViewDataSource];
    [self.navigationController pushViewController:videos animated:YES];
}

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

    if (nil != videos) [videos release];
    adBanner_.delegate = nil;
    [adBanner_ release];
    [super dealloc];
}

@end
