//
//  News.m
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 13/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "News.h"
#import "NewsDetailController.h"
#import "Constants.h"
#import "ServiceHandler.h"
#import "TableSubTitleItem.h"
#import "SharedObjects.h"
#import "NewsDataSource.h"
#import "DictionaryUtils.h"
#import "CelebrityAppDelegate.h"
#import "RootViewController.h"

@implementation News

@synthesize selectedNewsItem;
@synthesize newsDetailView;
@synthesize adBanner = adBanner_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
   
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(shareThis:) 
                                                     name:kshareNewsNotification 
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(tweetThis:) 
                                                     name:ktweetNewsNotification 
                                                   object:nil];
    }
    return self;
}

/*
- (void) viewDidLoad {

    [super viewDidLoad];
    
}*/

- (void) loadView {
    [super loadView];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.navigationController.toolbarHidden = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"news_title.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTranslucent:YES];

    UIImageView *backgroundTwitter = [[UIImageView alloc] init];
    backgroundTwitter.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    backgroundTwitter.image = [UIImage imageNamed:@"background.png"];
    
    CGPoint origin = CGPointZero;

    if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad) {
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
    
    self.variableHeightRows = YES;
    
    self.dataSource = [NewsDataSource newsDataSource];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (nil == newsDetailView) 
        newsDetailView = [[NewsDetailController alloc] init];
    
    newsDetailView.currentlySelectedNewsItem = [[[SharedObjects sharedInstance] newsArray] objectAtIndex:indexPath.row];
    
    [[self navigationController] pushViewController:newsDetailView animated:YES];
}

- (void) shareThis:(NSNotification*) notification {

    self.selectedNewsItem = [[notification userInfo] objectForKey:kNotificationShareKey];
    
    UIButton *button = (UIButton*)[notification object];

    if (nil != selectedNewsItem) {
        
        NSData *data = nil;
        
        NSMutableDictionary *shareParamsDict = nil;
        
        if ([[selectedNewsItem thumbImageUrl] length] > 0) {
            
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[selectedNewsItem thumbImageUrl]]];
            
            if ([data length] > 0) {
                
                shareParamsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [selectedNewsItem title], @"name",
                         [NSString stringWithFormat:@"Shared from %@ Mobile App - News feeds",kAppName], @"caption",
                                   [selectedNewsItem subTitle], @"description",
                                   data, @"picture",
                                   [selectedNewsItem url], @"link", nil];
            }
            else {
                
                shareParamsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [selectedNewsItem title], @"name",
                         [NSString stringWithFormat:@"Shared from %@ Mobile App - News feeds",kAppName], @"caption",
                                   [selectedNewsItem subTitle], @"description",
                                   kAppIconLink, @"picture",
                                   [selectedNewsItem url], @"link", nil];
            }
        }
        else {
            
            shareParamsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [selectedNewsItem title], @"name",
                         [NSString stringWithFormat:@"Shared from %@ Mobile App - News feeds",kAppName], @"caption",
                               [selectedNewsItem subTitle], @"description",
                               kAppIconLink, @"picture",
                               [selectedNewsItem url], @"link", nil];
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kFaceBookShareNotification 
                                                            object:button userInfo:shareParamsDict];

    }
}

- (void) tweetThis:(NSNotification*) notification {
    
    self.selectedNewsItem = [[notification userInfo] objectForKey:kNotificationShareKey];
    
    UIButton *button = (UIButton*)[notification object];
   
    NSMutableDictionary *shareParamsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            [selectedNewsItem title], @"caption",
                                            [selectedNewsItem url], @"link",
                                            nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTwitterShareNotification 
                                                        object:button userInfo:shareParamsDict];
}

- (void) dealloc {

    if (nil != selectedNewsItem) [selectedNewsItem release];
    if (nil != newsDetailView) [newsDetailView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kshareNewsNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ktweetNewsNotification object:nil];
    adBanner_.delegate = nil;
    [adBanner_ release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

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

@end
