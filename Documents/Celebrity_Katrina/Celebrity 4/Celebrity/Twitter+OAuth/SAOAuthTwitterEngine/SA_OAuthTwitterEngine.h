//
//  SA_OAuthTwitterEngine.h
//
//  Created by Ben Gottlieb on 24 July 2009.
//  Copyright 2009 Stand Alone, Inc.
//
//  Some code and concepts taken from examples provided by 
//  Matt Gemmell, Chris Kimpton, and Isaiah Carew
//  See ReadMe for further attributions, copyrights and license info.
//

#import "MGTwitterEngine.h"
//#import "ASIHTTPRequest.h"
#import "OASignatureProviding.h"

@protocol SA_OAuthTwitterEngineDelegate 
@optional
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username;					//implement these methods to store off the creds returned by Twitter
- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username;										//if you don't do this, the user will have to re-authenticate every time they run
- (void) twitterOAuthConnectionFailedWithData: (NSData *) data; 
@end


@class OAToken;
@class OAConsumer;

@interface SA_OAuthTwitterEngine : MGTwitterEngine {
	NSString	*_consumerSecret;
	NSString	*_consumerKey;
	NSURL		*_requestTokenURL;
	NSURL		*_accessTokenURL;
	NSURL		*_authorizeURL;
	NSString	*_pin;

   id<OASignatureProviding> signatureProvider;

@private
	OAConsumer	*_consumer;
	OAToken		*_requestToken;
	OAToken		*_accessToken; 
}

@property (retain) id<OASignatureProviding> signatureProvider;

@property (nonatomic, readwrite, retain) NSString *consumerSecret, *consumerKey;
@property (nonatomic, readwrite, retain) NSURL *requestTokenURL, *accessTokenURL, *authorizeURL;				//you shouldn't need to touch these. Just in case...
@property (nonatomic, readonly) BOOL OAuthSetup;

+ (SA_OAuthTwitterEngine *) OAuthTwitterEngineWithDelegate: (NSObject *) delegate;
- (SA_OAuthTwitterEngine *) initOAuthWithDelegate: (NSObject *) delegate;
- (BOOL) isAuthorized;

- (void) requestAccessToken;
- (void) requestRequestToken;
- (void) clearAccessToken;
- (OAToken *) getAccessToken;

- (NSString *)_sendRequestWithMethod:(NSString *)method 
                                path:(NSString *)path 
                     queryParameters:(NSDictionary *)params 
                                body:(NSString *)body 
                         requestType:(MGTwitterRequestType)requestType 
                        responseType:(MGTwitterResponseType)responseType;

@property (nonatomic, readwrite, retain)  NSString	*pin;
@property (nonatomic, readonly) NSURLRequest *authorizeURLRequest;
@property (nonatomic, readonly) OAConsumer *consumer;

@end
