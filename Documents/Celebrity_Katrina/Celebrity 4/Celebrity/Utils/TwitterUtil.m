//
//  TwitterUtil.m
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 19/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterUtil.h"
#import "SA_OAuthTwitterEngine.h"

#define kOAuthConsumerKey				@"ChdRPV280sOpAIDXoY5fw"		//REPLACE With Twitter App OAuth Key  
#define kOAuthConsumerSecret			@"hPmDKG4fYvYGfcs2kunULrOoQbz51Vh40KdkB7OTsFU"		//REPLACE With Twitter App OAuth Secret

@implementation TwitterUtil

@synthesize _engine;



-(void)updateTweets:(NSString*)tweet{
    if(!_engine){  
        [self loginToTwitter]; 
    }
}


-(void)loginToTwitter{
    
    if (!_engine) {
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        _engine.consumerKey    = kOAuthConsumerKey;  
        _engine.consumerSecret = kOAuthConsumerSecret;
    }
    
    if(![_engine isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        
        if (controller){  
           // [self presentModalViewController: controller animated: YES];  
        }  
    }
}

@end
