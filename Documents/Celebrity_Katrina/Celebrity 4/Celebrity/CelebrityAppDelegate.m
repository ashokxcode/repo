//
//  CelebrityAppDelegate.m
//  Celebrity
//
//  Created by chandramouli shivakumar on 2/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CelebrityAppDelegate.h"
#import "Constants.h"
#import "RootViewController.h"

@implementation CelebrityAppDelegate

@synthesize reachability;
@synthesize window = _window;
@synthesize rootViewController = _rootViewController;
@synthesize fbUtil;
@synthesize _engine;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupReachability];

    self.rootViewController = [[RootViewController alloc] init];
    
    self.fbUtil = [[FBUtil alloc] init];
    
    if (_engine == nil) {
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:[self rootViewController]];  
    }
    _engine.consumerKey    = kOAuthConsumerKey;  
    _engine.consumerSecret = kOAuthConsumerSecret;

    // Override point for customization after application launch.
    sleep(2);

    self.window.rootViewController = self.rootViewController;

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
    
    return [self.fbUtil.facebook handleOpenURL:URL];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url 
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation {
    
    return [self.fbUtil.facebook handleOpenURL:url];
}

#pragma mark -
#pragma mark Reachability and NetworkStatus

- (void) setupReachability 
{
    self.reachability = [Reachability reachabilityForInternetConnection];
    
    [self.reachability startNotifier];
}

- (void) reachabilityChanged:(NSNotification *)notification 
{
    Reachability* curReach = [notification object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    NSString* strReachableStatus = @"";
    
    switch (netStatus)
    {
        case NotReachable:
        {
            strReachableStatus = @"NotReachable";
            break;
        }
            
        case ReachableViaWWAN:
        {
            strReachableStatus = @"ReachableViaWWAN";
            break;
        }
        case ReachableViaWiFi:
        {
            strReachableStatus = @"ReachableViaWiFi";
            break;
        }
    }
    
    //updating the network switch timestamp
    //self.lastNetworkSwitch = [NSDate date];
}

- (BOOL) isNetworkAvailable
{
	if ([[self reachability] currentReachabilityStatus] != 0) 
    {
		return YES;
	}
    
	return NO;
}

#pragma mark SA_OAuthTwitterControllerDelegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
    
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	
    NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	
    NSLog(@"Authentication Canceled.");
}

#pragma mark SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData:(NSString *) data forUsername:(NSString *) username {
    
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

- (void)dealloc
{
    [reachability release];
    [fbUtil release];
    [_engine release];
    [_window release];
    [_rootViewController release];
    [super dealloc];
}

@end
