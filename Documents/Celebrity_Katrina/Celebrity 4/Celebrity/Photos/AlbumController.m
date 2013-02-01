//
//  AlbumController.m
//  Three20PhotoGallery
//
//  Created by JayaPrathap Audikesavalu on 13/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "AlbumController.h"
#import "PhotoSource.h"
#import "Photo.h"
#import "ServiceHandler.h"
#import "Constants.h"
#import "DictionaryUtils.h"
#import "SharedObjects.h"
#import "CelebrityAppDelegate.h"
#import "RootViewController.h"

@implementation AlbumController

@synthesize photoView;
@synthesize adBanner = adBanner_;

- (id)init
{
	if (self = [super init]) 
	{
		// Initialization code
	}
	return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"pictures_title.png"] 
                                                  forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *backgroundTwitter = [[UIImageView alloc] init];
    backgroundTwitter.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 
                                         [[UIScreen mainScreen] bounds].size.height);
    backgroundTwitter.image = [UIImage imageNamed:@"background.png"];

    CGPoint origin = CGPointZero;

    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        self.tableView.frame = CGRectMake(0, 25, [[UIScreen mainScreen] bounds].size.width, 
                                          [[UIScreen mainScreen] bounds].size.height - 20);
        origin = CGPointMake(0.0, self.tableView.frame.size.height-
                             CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height);
    }
    else {
    
        origin = CGPointMake(0.0, [[UIScreen mainScreen] bounds].size.height-
                             CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height - 20);
        
        self.tableView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 
                                          [[UIScreen mainScreen] bounds].size.height - CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height);
    }
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.separatorColor = [UIColor clearColor];

    [self.view insertSubview:backgroundTwitter belowSubview:self.tableView];
    [backgroundTwitter release];

    self.photoSource = [[SharedObjects sharedInstance] photoSource];
    
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
    //[self.tableView setTableFooterView:[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease]];
    [self.view addSubview:self.adBanner];
}

- (void)thumbsTableViewCell:(TTThumbsTableViewCell*)cell didSelectPhoto:(id<TTPhoto>)photo {
    
    [_delegate thumbsViewController:self didSelectPhoto:photo];
    
    BOOL shouldNavigate = YES;
    if ([_delegate respondsToSelector:@selector(thumbsViewController:shouldNavigateToPhoto:)]) {
        shouldNavigate = [_delegate thumbsViewController:self shouldNavigateToPhoto:photo];
    }
    
    if (shouldNavigate) {
        NSString* URL = [self URLForPhoto:photo];
        if (URL) {
            TTOpenURLFromView(URL, self.view);
        } 
        else {
            PhotoViewController *tempPhotoView = [[PhotoViewController alloc] init];
            self.photoView = tempPhotoView;
            [tempPhotoView release];
            self.photoView.centerPhoto = photo;
            [self.navigationController pushViewController:self.photoView animated:YES];
        }
    }
}

- (NSString*)URLForPhoto:(id<TTPhoto>)photo {
    
    if ([photo respondsToSelector:@selector(URLValueWithName:)]) {
        return [photo URLValueWithName:@"TTPhotoViewController"];
        
    } else {
        return nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    }
    
    return NO;
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
	
    if (nil != photoView) [photoView release];
    adBanner_.delegate = nil;
    [adBanner_ release];
	[super dealloc];
}

@end
