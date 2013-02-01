//
//  NewsDetailViewController.m
//  CelebrityApp
//
//  Created by JayaPrathap Audikesavalu on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsDetailController.h"
#import "Constants.h"
#import "SharedObjects.h"
#import "DictionaryUtils.h"
#import "CelebrityAppDelegate.h"
#import "RootViewController.h"

@implementation NewsDetailController

@synthesize scrollView;
@synthesize currentlySelectedNewsItem;
@synthesize descWebView;
@synthesize contentString, moreButton, viewUnderline;
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
- (void)loadView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    UIView *ContentView = [[UIView alloc] initWithFrame:screenRect];
	self.view = ContentView;
	[ContentView release];
	self.view.opaque = YES;

    UIImageView *backgroundTwitter = [[UIImageView alloc] init];
    backgroundTwitter.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    backgroundTwitter.image = [UIImage imageNamed:@"background.png"];
    [self.view addSubview:backgroundTwitter];
    [backgroundTwitter release];

    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];
    
    image = [[TTImageView alloc] initWithFrame:CGRectZero];
    image.style = [TTSolidFillStyle styleWithColor:[UIColor clearColor] next:
                   [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:10.0f] next:
                    [TTContentStyle styleWithNext:nil]]];
    [scrollView addSubview:image];

    descWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    descWebView.delegate = self;
    [descWebView setBackgroundColor:[UIColor clearColor]];
    descWebView.opaque = NO;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0) {
        
        for (id subview in descWebView.subviews)
            if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                ((UIScrollView *)subview).bounces = NO;
    }
    else {
    
        [[descWebView scrollView] setBounces:NO];
        [[descWebView scrollView] setScrollEnabled:NO];
    }
    [scrollView addSubview:descWebView];
    
    CGPoint origin = CGPointZero;
    
    moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setTitle:@"More.." forState:UIControlStateNormal];
    [moreButton setTitleColor:kFontColor forState:UIControlStateNormal];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [moreButton.titleLabel setFont:kFontHelveticaBold22];
        
        origin = CGPointMake(0.0, self.view.frame.size.height - CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height-10);
    }
    else {
        [moreButton.titleLabel setFont:kFontHelveticaBold13];
        
        origin = CGPointMake(0.0, self.view.frame.size.height - CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height-15);
    }
    [moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:moreButton];
    
    //underline code
    viewUnderline = [[UIView alloc] init];
    viewUnderline.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:viewUnderline];
    [viewUnderline release];  

    webController = [[NewsWebController alloc] init];
    
    ///////////////// AdMob Integration ///////////////////
    
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*) [[UIApplication sharedApplication] delegate];

    // Initialize the banner at the bottom of the screen.
        
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.adBanner = [[[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait 
                                                    origin:origin] autorelease];
    
    self.adBanner.adUnitID = INTERSTITIAL_AD_UNIT_ID;
    self.adBanner.delegate = [delegate rootViewController];
    [self.adBanner setRootViewController:[delegate rootViewController]];
    [self.view addSubview:self.adBanner];
    [self.view bringSubviewToFront:self.adBanner];
    
    [self.adBanner loadRequest:[[DictionaryUtils sharedInstance] createRequest]];

}

-(void)back {  
    
    if ([self.navigationController.navigationBar viewWithTag:130]) {
        [[self.navigationController.navigationBar viewWithTag:130] removeFromSuperview];
    }
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) initNewsDetailView {

    [self.navigationItem setHidesBackButton:YES];
    
    [self.navigationController.navigationBar setTranslucent:YES];

    // Set the custom back button
    if (![self.navigationController.navigationBar viewWithTag:130]) {
    
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 130;
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
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
        
    CGRect titleViewFrame = CGRectZero;
    CGRect imageFrame = CGRectZero;
    CGRect descFrame = CGRectZero;
    CGRect moreButtonFrame = CGRectZero;
    CGRect underlineFrame = CGRectZero;
    
    CGSize tsize = CGSizeZero;
    CGSize dsize = CGSizeZero;
    
    self.navigationController.toolbarHidden = YES;

    contentString = @"";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        scrollView.contentSize = CGSizeMake(768, 1090);
        
        tsize = [[DictionaryUtils sharedInstance] getTextSize:[[self currentlySelectedNewsItem] title] 
                                    constrainedToSize:CGSizeMake(650, 60) 
                                             withFont:[UIFont systemFontOfSize:24]];
        
        titleViewFrame =  CGRectMake(60, 105, tsize.width + 40, tsize.height + 35);
        
        dsize = [[DictionaryUtils sharedInstance] getTextSize:[[self currentlySelectedNewsItem] subTitle] 
                                    constrainedToSize:CGSizeMake(650, 450) 
                                             withFont:[UIFont systemFontOfSize:24]];
        
        imageFrame = CGRectMake(screenRect.size.width/3+60, titleViewFrame.size.height+40, 130, 130);
        
        descFrame = CGRectMake(titleViewFrame.origin.x, 
                               imageFrame.origin.y+imageFrame.size.height + 40, 
                               dsize.width + 10, dsize.height + 40);
        
        moreButtonFrame = CGRectMake(descFrame.origin.x, descFrame.origin.y+descFrame.size.height+25, 75, 45);
        
        underlineFrame = CGRectMake(moreButtonFrame.origin.x, moreButtonFrame.origin.y+moreButtonFrame.size.height+5, 
                                    moreButtonFrame.size.width, 1);
        
        contentString = [NSString stringWithFormat:@"<html> \n"
                         "<head> \n"
                         "<style type=\"text/css\"> \n"
                         "body {font-family: \"%@\"; font-size: %@; bgcolor=\"#000000\" text=\"#FFFFFF\"}\n"
                         "</style> \n"
                         "</head> \n"
                         "<body p style='color:black'>%@</body> \n"
                         "</html>", @"Helvetica", [NSNumber numberWithInt:24], [[self currentlySelectedNewsItem] subTitle]];
        
        [image setDefaultImage:[UIImage imageNamed:@"Icon@2x.png"]];
    }
    else {
        scrollView.contentSize = CGSizeMake(320, 500);
        
        tsize = [[DictionaryUtils sharedInstance] getTextSize:[[self currentlySelectedNewsItem] title] 
                                    constrainedToSize:CGSizeMake(290, 40) 
                                             withFont:[UIFont systemFontOfSize:15.0]];
        
        titleViewFrame =  CGRectMake(10, 80, tsize.width + 40, tsize.height + 35);
        
        dsize = [[DictionaryUtils sharedInstance] getTextSize:[[self currentlySelectedNewsItem] subTitle] 
                                    constrainedToSize:CGSizeMake(290, 150) 
                                             withFont:[UIFont systemFontOfSize:13.0]];
        
        imageFrame = CGRectMake(screenRect.size.width/2-35, titleViewFrame.size.height+10, 80, 80);
        
        descFrame = CGRectMake(titleViewFrame.origin.x, 
                               imageFrame.origin.y+imageFrame.size.height + 10, 
                               dsize.width + 10, 
                               dsize.height + 40);
        
        moreButtonFrame = CGRectMake(descFrame.origin.x, descFrame.origin.y+descFrame.size.height+20, 50, 30);

        underlineFrame = CGRectMake(moreButtonFrame.origin.x, moreButtonFrame.origin.y+moreButtonFrame.size.height, 
                                    moreButtonFrame.size.width, 1);
        
        contentString = [NSString stringWithFormat:@"<html> \n"
                         "<head> \n"
                         "<style type=\"text/css\"> \n"
                         "body {font-family: \"%@\"; font-size: %@; bgcolor=\"#000000\" text=\"#FFFFFF\"}\n"
                         "</style> \n"
                         "</head> \n"
                         "<body p style='color:black'>%@</body> \n"
                         "</html>", @"Helvetica", [NSNumber numberWithInt:13], [[self currentlySelectedNewsItem] subTitle]];
        
        [image setDefaultImage:[UIImage imageNamed:@"Icon.png"]];
    }
    
    [image setFrame:imageFrame];

    [descWebView setFrame:descFrame];
    
    [moreButton setFrame:moreButtonFrame];

    [viewUnderline setFrame:underlineFrame];
        
    NSString *mediaUrl = [NSString stringWithFormat:@"%@",[[self currentlySelectedNewsItem] thumbImageUrl]]; //detailImage
	
    if(nil != mediaUrl) {
		
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:mediaUrl]];
		
        if ([imageData length] > 0) {
            
            [image setDefaultImage:[UIImage imageWithData:imageData]];
        }
	}
        
    [descWebView loadHTMLString:contentString baseURL:nil];
}

- (void) moreButtonAction {

    [webController setHeaderView:[[[UIView alloc] init] autorelease]];
    [webController openURL:[NSURL URLWithString:[[self currentlySelectedNewsItem] url]]];
    
    // Push the controller to the navigation controller stack
    [self.navigationController pushViewController:webController animated:YES];
}

- (void) dismissView:(id) sender {
    
    if (nil != sender) {
        UIButton *button = (UIButton*) sender;
        [button removeFromSuperview];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark WebView delegate 
#pragma mark

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType {

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"news_title.png"]
                                                  forBarMetrics:UIBarMetricsDefault];

}

- (void)viewWillAppear:(BOOL)animated {

    //[super viewWillAppear:animated];

    self.navigationController.toolbarHidden = NO;
    
    [self initNewsDetailView];
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

    TT_RELEASE_SAFELY(image);
    if (nil != contentString) contentString = nil;
    if (nil != scrollView) [scrollView release];
    if (nil != descWebView) [descWebView release];
    if (nil != currentlySelectedNewsItem) [currentlySelectedNewsItem release];
    TT_RELEASE_SAFELY(webController);
    adBanner_.delegate = nil;
    [adBanner_ release];
    [super dealloc];
}

@end
