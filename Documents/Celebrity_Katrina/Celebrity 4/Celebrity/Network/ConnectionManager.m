//
//  ConnectionManager.m
//  iShop 2.0
//
//  Created by Srivatsa S. on 10/28/10.
//  Copyright Photon Infotech (P) Ltd. 2010. All rights reserved.
//


#import "ConnectionManager.h"
#import "Reachability.h"
#import "DebugOutput.h"

static ConnectionManager *sharedConnection = nil;

@implementation ConnectionManager

+ (ConnectionManager*)sharedConnections
{
    if (sharedConnection == nil) {
		
		sharedConnection = [[super allocWithZone:NULL] init];
    }
    return sharedConnection;
}


-(void) serviceCallWithRequest:(id)reqParamsDict
{	
	NSString *aURLString = [reqParamsDict objectForKey:@"URL"];
	
	NSString* aHttpBody = [reqParamsDict objectForKey:@"httpBody"];
	
	NSString* aHttpMethod = [reqParamsDict objectForKey:@"httpMethod"]; 
	
	id callBackTarget = [reqParamsDict objectForKey:@"callbackTarget"] ; 
	
	id callBackID = [reqParamsDict objectForKey:@"callbackID"] ; 
	
	NSString* callBackSelector = [reqParamsDict objectForKey:@"callbackSelector"]; 
	
	NSNumber *isErrorHandlingRequired = [reqParamsDict objectForKey:kisErrorHandlingRequired];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: aURLString]];
	
	NSData *httpBody = [NSData dataWithBytes: [aHttpBody UTF8String] length: [aHttpBody length]] ;
	
	// Differentiating between GET/POST method.
	// In GET: We don't set http body becuase we send parameters along with url. We append parameters after adding '?' at end of url.
	// In POST: We set http body
	if([aHttpMethod isEqualToString:@"POST"])
	{
		request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: aURLString]];
		
		httpBody = [NSData dataWithBytes: [aHttpBody UTF8String] length: [aHttpBody length]];
		
		[request setHTTPBody:httpBody];
	}
	else if([aHttpMethod isEqualToString:@"GET"]) {
		
		aURLString = [NSString stringWithFormat:@"%@?%@", aURLString, aHttpBody];
		
		request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: aURLString]];
	}
	
	
	[request setHTTPMethod:aHttpMethod];
	
	NSDictionary *reqHeaders = [reqParamsDict objectForKey:@"httpHeaders"];
	
	if(nil != reqHeaders) {
		for (NSString *httpHeader in reqHeaders) {
			[request setValue:[reqHeaders objectForKey:httpHeader] forHTTPHeaderField:httpHeader];
		}
	}
	
		
	//create a new connectino and data buffer	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	
	NSMutableData *connectionData = [ [NSMutableData alloc] init];
	
	if ([isErrorHandlingRequired boolValue]) {
		if(FALSE == [self checkInternetConnection:connection])
		{
			[connection release]; 
			connection = nil;
			[connectionData release]; 
			connectionData = nil;
			
			return;
		}
	}
	
	
	NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
	
	[tempDict setObject:connection forKey:kConnection];
	[tempDict setObject:aURLString forKey:kConnectionURL];
	[tempDict setObject:connectionData forKey:kConnectionDataReceived];
	[tempDict setObject:callBackTarget forKey:kConnectionCallbackTarget];
	[tempDict setObject:callBackSelector forKey:kConnectionCallbackSelector];
	[tempDict setObject:callBackID forKey:kConnectionCallbackID];
//	[tempDict setObject:isErrorHandlingRequired forKey:kisErrorHandlingRequired];
	
	
	//create the array of connection, data and callback selectors
	if(urlConnectionsArray==nil)
	{
		urlConnectionsArray = [[NSMutableArray  alloc] init];
	}		
	
	
	//Add the connection to array
	[urlConnectionsArray addObject:tempDict];
	
	//it is retained in setobj
	[connection release];	
	connection = nil;
	
	[connectionData release];	
	connectionData = nil;
	
}

//Use this in case we need to pass callback ID...
- (void)serviceCallWithURL: (NSString*)aURLString
				  httpBody: (NSString*)aHttpBody 
			   httpMethod : (NSString*)aHttpMethod
			callBackTarget: (id)callBackTarget
		  callBackSelector: (SEL)callBackSelector
				callBackID: (id)callbackID
{
	//pass all the data to be executed on the main thread
	NSMutableDictionary *serviceReq=[NSMutableDictionary dictionary];
	
	[serviceReq setObject:aURLString forKey:@"URL"];
	
	[serviceReq setObject:aHttpBody forKey:@"httpBody"];
	
	[serviceReq setObject:aHttpMethod forKey:@"httpMethod"];
	
	[serviceReq setObject:callbackID forKey:@"callbackID"];
	
	[serviceReq setObject:callBackTarget forKey:@"callbackTarget"];
	
	[serviceReq setObject:NSStringFromSelector(callBackSelector) forKey:@"callbackSelector"];
	
	NSMutableDictionary *requestHeaders = [NSMutableDictionary dictionary];	
	
	[serviceReq  setObject:requestHeaders forKey:@"httpHeaders"];
	
	[self performSelectorOnMainThread:@selector(serviceCallWithRequest:) withObject:serviceReq waitUntilDone:YES];	
}

/////////////////////////////////////////////////////////////////////
//                  Helper functinos to 
//					1.get a connectinon object form urlConnectionsArray
//					2.Remove a conn obj from array
/////////////////////////////////////////////////////////////////////

-(void) deleteConnObj:(NSURLConnection *)conn
{
	//delete a specified connection object
	for(NSInteger i = 0; i < [urlConnectionsArray count]; i++) {
		
		id connection = (NSURLConnection *) [[urlConnectionsArray objectAtIndex:i] objectForKey:kConnection];
		
		if( (NSURLConnection *)connection == conn)
		{
			id connobj = [urlConnectionsArray objectAtIndex:i];
			
			[connobj release];
			
			connobj = nil;
			
			[urlConnectionsArray removeObjectAtIndex:i];			
		}
	}
}

-(id) getConnectionObj:(NSURLConnection *)conn
{
	for(NSInteger i = 0; i < [urlConnectionsArray count]; i++) {
		id connobj = (NSURLConnection *) [[urlConnectionsArray objectAtIndex:i] objectForKey:kConnection];
		if( (NSURLConnection *)connobj == conn) {
			return [urlConnectionsArray objectAtIndex:i];
		}		
	}
	return nil;
}


/////////////////////////////////////////////////////////////////////
//
//                  NSURLConnection delegates 
//
/////////////////////////////////////////////////////////////////////

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	id connObj = [self getConnectionObj:connection];
	
	//replace the existing response object for this connection with one jsut recieved...	
	[connObj setObject:response  forKey:kConnectionServerResponse];	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	id connObj = [self getConnectionObj:connection];
	
	[[connObj objectForKey:kConnectionDataReceived] appendData:data];
	
	BOOL isErrorHandlingRequired = [[connObj objectForKey:kisErrorHandlingRequired] boolValue];
	
	if (isErrorHandlingRequired) {
		
		if(!isServiceDown)
		{
			[self serviceErrorHandling:connection];
		}
	}	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{	
	id connObj = [self getConnectionObj:connection];
	
	id tempCallBackTarget = [connObj objectForKey:kConnectionCallbackTarget];
	
	SEL tempCallBackSelector =  NSSelectorFromString([connObj objectForKey:kConnectionCallbackSelector]);
	
	//send the data back to callback...
	if([tempCallBackTarget respondsToSelector:tempCallBackSelector]) 
	{
		if( [connObj objectForKey:kConnectionCallbackID] == [NSNull null])
		{
			[tempCallBackTarget performSelector:tempCallBackSelector withObject:[connObj objectForKey:kConnectionDataReceived] ];
		}
		else{
			NSMutableDictionary *dict=[NSMutableDictionary dictionary];
			
			[dict setValue:[connObj objectForKey:kConnectionCallbackID] forKey:kConnectionCallbackID];
			
			[dict setValue:[connObj objectForKey:kConnectionDataReceived] forKey:kConnectionDataReceived];
			
			[dict setValue:[connObj objectForKey:kConnectionURL] forKey:kConnectionURL];
			
			[tempCallBackTarget performSelector:tempCallBackSelector withObject:dict ];
		}
	}
	
	[self deleteConnObj:connection];	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	id connObj = [self getConnectionObj:connection];
	
	
	id tempCallBackTarget = [connObj objectForKey:kConnectionCallbackTarget];
	
	SEL tempCallBackSelector = NSSelectorFromString([connObj objectForKey:kConnectionCallbackSelector]);
		
	if (connObj != nil) {
		BOOL isErrorHandlingRequired = [[connObj objectForKey:kisErrorHandlingRequired] boolValue];
		if (isErrorHandlingRequired) {
			if(!isServiceDown)
			{
				[self serviceErrorHandling:connection];
			}
		}
		else {
			NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[connObj objectForKey:kConnectionURL]]];
			[[connObj objectForKey:kConnectionDataReceived] appendData:data];
		}
		
	}
	
	NSMutableDictionary *dict=[NSMutableDictionary dictionary];
	
	[dict setValue:[connObj objectForKey:kConnectionCallbackID] forKey:kConnectionCallbackID];
	
	[dict setValue:[connObj objectForKey:kConnectionDataReceived] forKey:kConnectionDataReceived];
	
	[dict setValue:[connObj objectForKey:kConnectionURL] forKey:kConnectionURL];	
	
	//Call the delegateMethod
	if([tempCallBackTarget respondsToSelector:tempCallBackSelector]) 
	{
		[tempCallBackTarget performSelector:tempCallBackSelector withObject:dict];
	}
	
}


- (BOOL) checkInternetConnection:(NSURLConnection *)connection{
	
	//if([[Reachability sharedReachability] internetConnectionStatus]==0) {
	NSError *error;
	[self connection:connection didFailWithError:error]; 
	return FALSE;
	//}
	return TRUE;
}

//This cancels all the current requests
- (void)cancel {
	
	for(int i=0;i<[urlConnectionsArray count];i++)
	{
		id connobj = [urlConnectionsArray objectAtIndex:i];
				
		[(NSURLConnection *)[connobj objectForKey:kConnection] cancel];
		
		[self deleteConnObj:[connobj objectForKey:kConnection]];
		
	}
}

-(id)getCallbackID{
	
	return [NSString stringWithFormat:@"%d", ++callbackIDCounter];
}


/////////////////////////////////////////////////////////////////////
//                  Error Handling funcs
/////////////////////////////////////////////////////////////////////

- (BOOL)isResponseNil:(NSURLResponse *) response {
	
	debug(@"HTTP service response status code: %d", [(NSHTTPURLResponse*)response statusCode]);
	
	if([response isKindOfClass:[NSHTTPURLResponse class]]) {
		
		if([(NSHTTPURLResponse*)response statusCode] != SUCESS_STATUS_CODE) {
			
			return YES;
		}
		else {
			return NO;
		}
	}
	
	return NO;
}

- (BOOL) serviceErrorHandling:(NSURLConnection *)connection
{
	id connObj = [self getConnectionObj:connection];
	
	NSURLResponse *serverResp = [connObj objectForKey:kConnectionServerResponse];
	
	if([self isResponseNil:serverResp]){
		isServiceDown = YES;
	}
	
	return isServiceDown;
}

- (void)dealloc {
	[urlConnectionsArray release];
	[super dealloc];
}

@end