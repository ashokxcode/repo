//
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ServiceHandler.h"
#import "ConnectionManager.h"
#import "SharedObjects.h"
#import "DataModelEntities.h"
#import "JSON.h"
#import "CelebrityAppDelegate.h"
#import "Constants.h"
#import "DebugOutput.h"
#import "DictionaryUtils.h"

@implementation ServiceHandler

@synthesize callBackTarget;
@synthesize callBackSelector;

- (void) callService:(id)callBackTargetMethod: (SEL)callBackSelectorMethod :(NSString*)serviceName {
    
  	self.callBackTarget = callBackTargetMethod;
	
	self.callBackSelector = callBackSelectorMethod;
	
    NSString *urlString = [NSString stringWithFormat:@"http://x-valuetech.com/katrina/index.php?%@",serviceName];
    
    NSString *param = @"user_id=49";
    
    if ([serviceName isEqualToString:@"photos"]) {
        
        [[ConnectionManager sharedConnections] serviceCallWithURL:urlString 
                                                         httpBody:param 
                                                       httpMethod:@"POST" 
                                                   callBackTarget:self 
                                                 callBackSelector:@selector(callPictureServiceDone:) 
                                                       callBackID:[[ConnectionManager sharedConnections] getCallbackID]];
    }
    else if ([serviceName isEqualToString:@"newsletter"]) {
        
        [[ConnectionManager sharedConnections] serviceCallWithURL:urlString 
                                                         httpBody:param 
                                                       httpMethod:@"POST" 
                                                   callBackTarget:self 
                                                 callBackSelector:@selector(callNewsServiceDone:) 
                                                       callBackID:[[ConnectionManager sharedConnections] getCallbackID]];
    }
}

- (void) callPictureServiceDone:(NSMutableDictionary*) responseDataDict {
    
    if (nil != [[SharedObjects sharedInstance] serviceDownInfo]) {
        
        if ([[[SharedObjects sharedInstance] serviceDownInfo] count] > 0) {
            
            [[[SharedObjects sharedInstance] serviceDownInfo] removeAllObjects];
        }
    }
    
    DictionaryUtils *dictUtils = [DictionaryUtils sharedInstance];
    
    NSData *responseData = [responseDataDict objectForKey:kConnectionDataReceived];
	
	NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
	NSMutableDictionary *serviceResponse;
	
    if ([string length] != 0) {
        
        NSString *responseResultString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        SBJsonParser *jsonParser = [SBJsonParser new];
        
        // Parse the JSON into an Object		
        id data = [jsonParser objectWithString:responseResultString];
        
        [responseResultString release];
        responseResultString = nil;
        
        //Release SBJSon Object
        [jsonParser release];
        jsonParser = nil;
        
        if (nil != data) {
            
            serviceResponse = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)data];
            
            if ([dictUtils dict:serviceResponse hasKey:kStatus_code] && 
                [dictUtils dict:serviceResponse hasKey:kStatus]) {
                
                if ([[serviceResponse objectForKey:kStatus_code] isEqualToString:kSuccess_code] &&
                    [[serviceResponse objectForKey:kStatus] isEqualToString:kSuccess]) {
                    
                    // Photos available in service
                    [[SharedObjects sharedInstance] updatePics:[serviceResponse objectForKey:kData]];
                }
                else {
                    
                    // Photos unavailable
                    if ([dictUtils dict:[serviceResponse objectForKey:kData] hasKey:kMessage]) {
                        
                        [[[SharedObjects sharedInstance] serviceDownInfo] setObject:[[serviceResponse objectForKey:kData] objectForKey:kMessage] 
                                                                             forKey:[serviceResponse objectForKey:kService_name]];
                        
                    }
                }
            }
            
            [self.callBackTarget performSelectorOnMainThread:self.callBackSelector withObject:nil waitUntilDone:NO];	
        }
        else {
            
            NSDictionary *errorDict = [NSDictionary dictionaryWithObject:@"Parse error occured" forKey:@"Error"];
            
            [self.callBackTarget performSelectorOnMainThread:self.callBackSelector withObject:errorDict waitUntilDone:NO];	
        }
    }
    else
	{
		NSDictionary *errorDict = [NSDictionary dictionaryWithObject:@"Network error occured" forKey:@"Error"];
		
		[self.callBackTarget performSelectorOnMainThread:self.callBackSelector withObject:errorDict waitUntilDone:NO];        
	}
	
	[string release];
}


- (void) callNewsServiceDone:(NSMutableDictionary*) responseDataDict {
    
    if (nil != [[SharedObjects sharedInstance] serviceDownInfo]) {
        
        if ([[[SharedObjects sharedInstance] serviceDownInfo] count] > 0) {
            
            [[[SharedObjects sharedInstance] serviceDownInfo] removeAllObjects];
        }
    }
    
    DictionaryUtils *dictUtils = [DictionaryUtils sharedInstance];
    
    NSData *responseData = [responseDataDict objectForKey:kConnectionDataReceived];
	
	NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
	NSMutableDictionary *serviceResponse;
	
    if ([string length] != 0) {
        
        NSString *responseResultString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        SBJsonParser *jsonParser = [SBJsonParser new];
        
        // Parse the JSON into an Object		
        id data = [jsonParser objectWithString:responseResultString];
        
        [responseResultString release];
        responseResultString = nil;
        
        //Release SBJSon Object
        [jsonParser release];
        jsonParser = nil;
        
        if (nil != data) {
            
            serviceResponse = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)data];
            
            if ([dictUtils dict:serviceResponse hasKey:kStatus_code] && 
                [dictUtils dict:serviceResponse hasKey:kStatus]) {
                
                if ([[serviceResponse objectForKey:kStatus_code] isEqualToString:kSuccess_code] &&
                    [[serviceResponse objectForKey:kStatus] isEqualToString:kSuccess]) {
                    
                    // News available in service
                    [[SharedObjects sharedInstance] updateNews:[serviceResponse objectForKey:kData]];
                }
                else {
                    
                    // News unavailable
                    if ([dictUtils dict:[serviceResponse objectForKey:kData] hasKey:kMessage]) {
                        
                        [[[SharedObjects sharedInstance] serviceDownInfo] setObject:[[serviceResponse objectForKey:kData] objectForKey:kMessage] 
                                                                             forKey:[serviceResponse objectForKey:kService_name]];
                        
                    }
                }
            }
            
            [self.callBackTarget performSelectorOnMainThread:self.callBackSelector withObject:nil waitUntilDone:NO];	
        }
        else {
            
            NSDictionary *errorDict = [NSDictionary dictionaryWithObject:@"Parse error occured" forKey:@"Error"];
            
            [self.callBackTarget performSelectorOnMainThread:self.callBackSelector withObject:errorDict waitUntilDone:NO];	
        }
    }
    else
	{
		NSDictionary *errorDict = [NSDictionary dictionaryWithObject:@"Network error occured" forKey:@"Error"];
		
		[self.callBackTarget performSelectorOnMainThread:self.callBackSelector withObject:errorDict waitUntilDone:NO];        
	}
	
	[string release];
}

- (void) callVideosService:(id)callBackTargetMethod: (SEL)callBackSelectorMethod :(NSString*) playlistId {
    
    self.callBackTarget = callBackTargetMethod;
	
	self.callBackSelector = callBackSelectorMethod;
	
    NSString *urlString = [NSString stringWithFormat:@"https://gdata.youtube.com/feeds/api/playlists/%@",playlistId];
    
    CelebrityAppDelegate *delegate = (CelebrityAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([delegate isNetworkAvailable]) {

        [[ConnectionManager sharedConnections] serviceCallWithURL:urlString 
                                                         httpBody:[NSString stringWithFormat:@"v=2&alt=jsonc&max-results=50"] 
                                                       httpMethod:@"GET" 
                                                   callBackTarget:self 
                                                 callBackSelector:@selector(callVideosServiceDone:) 
                                                       callBackID:[[ConnectionManager sharedConnections] getCallbackID]];

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

- (void) callVideosServiceDone:(NSMutableDictionary*) responseDataDict {
    
    NSData *responseData = [responseDataDict objectForKey:kConnectionDataReceived];
	
	NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
	NSMutableDictionary *videoServiceResponse;
	
    if ([string length] > 0) {
        
        NSString *responseResultString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        SBJsonParser *jsonParser = [SBJsonParser new];
        
        // Parse the JSON into an Object		
        id data = [jsonParser objectWithString:responseResultString];
        
        [responseResultString release];
        responseResultString = nil;
        
        //Release SBJSon Object
        [jsonParser release];
        jsonParser = nil;
        
        if (nil != data) {
            
            videoServiceResponse = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)data];
            
            [[SharedObjects sharedInstance] updateVideos:videoServiceResponse];
            
            [self.callBackTarget performSelectorOnMainThread:self.callBackSelector withObject:nil waitUntilDone:NO];	
        }
        else {
            
            NSDictionary *errorDict = [NSDictionary dictionaryWithObject:@"Parse error occured" forKey:@"Error"];
            
            [self.callBackTarget performSelectorOnMainThread:self.callBackSelector withObject:errorDict waitUntilDone:NO];	
        }
    }
    else
	{
		NSDictionary *errorDict = [NSDictionary dictionaryWithObject:@"Network error occured" forKey:@"Error"];
		
		[self.callBackTarget performSelectorOnMainThread:self.callBackSelector withObject:errorDict waitUntilDone:NO];        
	}
	
	[string release];
}

@end
