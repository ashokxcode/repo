//
//  FBUtil.m
//  FBTester
//
//  Created by  on 20/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FBUtil.h"
#import "Constants.h"
#import "CelebrityAppDelegate.h"

@implementation FBUtil

@synthesize facebook = _facebook;
@synthesize queuedWallData;

-(id) init
{
    self = [super init];
    
    if(self != Nil)
    {
        // Initialize Facebook
        self.facebook = [[Facebook alloc] initWithAppId:_APP_KEY andDelegate:self];
        
        // Check and retrieve authorization information
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
            self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
        
//        self.queuedWallData = Nil;
    }
    
    return self;
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

/**
 * Show the authorization dialog.
 */
- (void) login//:(NSMutableDictionary*)postData
{
    //self.queuedWallData = postData;
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_stream", nil];

    [self.facebook authorize:permissions];

    [permissions release];
}

- (void) postPhotoToWall: (NSMutableDictionary*) wallData
{
    [self.facebook requestWithGraphPath:@"photos"
                              andParams:wallData
                          andHttpMethod:@"POST"
                            andDelegate:self];
}

- (void) shareNewsAndVideo:(NSMutableDictionary*) params {
    
    [self.facebook requestWithGraphPath:@"feed"
                                    andParams:params
                                andHttpMethod:@"POST"
                                  andDelegate:self];
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void) logout 
{
    [self.facebook logout];
}


-(void) dealloc
{
    [self.facebook release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark FBSessionDelegate

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin
{
    [self storeAuthData:[ self.facebook accessToken] expiresAt:[ self.facebook expirationDate]];
    
    //[self postToWall:queuedWallData];
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
   // NSLog(@"fbDidNotLogin");
    [[[[UIAlertView alloc] initWithTitle:Nil message:@"Facebook Login failed" 
                                delegate:Nil 
                       cancelButtonTitle:@"OK" 
                       otherButtonTitles:nil] autorelease] show];
}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
   // NSLog(@"fbDidExtendToken");
    
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
   // NSLog(@"fbDidLogout");
   // [[[[UIAlertView alloc] initWithTitle:Nil message:@"fbDidLogout" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];

}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated
{
    //NSLog(@"fbSessionInvalidated");
    
    [self fbDidLogout];
}


- (void)dialogCompleteWithUrl:(NSURL *)url 
{
//    [[[[UIAlertView alloc] initWithTitle:Nil message:[url query] delegate:Nil 
//cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    
}

#pragma mark - FBRequestDelegate Methods

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"received response");
}

- (void)request:(FBRequest *)request didLoad:(id)result {

    // remove loading indicator
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[delegate rootViewController] removeLoadingView];
    
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:nil 
                                                     message:@"Share successful" 
                                                    delegate:nil 
                                           cancelButtonTitle:@"Ok" 
                                           otherButtonTitles:nil];
    [alert1 show];
    [alert1 release];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {

    // remove loading indicator
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[delegate rootViewController] removeLoadingView];
    
    UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:nil 
                                                     message:@"Share failed. Please try again" 
                                                    delegate:nil 
                                           cancelButtonTitle:@"Ok" 
                                           otherButtonTitles:nil];
    [alert2 show];
    [alert2 release];
}
     
@end
