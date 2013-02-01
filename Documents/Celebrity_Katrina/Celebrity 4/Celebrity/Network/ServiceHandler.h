//
//  PDPServiceHandler.h
//  iShop2.0
//
//  Created by PHOTON on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServiceHandler : NSObject {

@private
	id callBackTarget;
	SEL callBackSelector;	
	
}

@property(assign) id callBackTarget;
@property(assign) SEL callBackSelector;

-(void) twitterService:(id)callBackTargetMethod: (SEL)callBackSelectorMethod;
-(void) twitterServiceDone:(NSMutableDictionary*) responseDataDict;
-(void) callService:(id)callBackTargetMethod: (SEL)callBackSelectorMethod :(NSString*)serviceName;
-(void) callPictureServiceDone:(NSMutableDictionary*) responseDataDict;
-(void) callNewsServiceDone:(NSMutableDictionary*) responseDataDict;
-(void) callVideosService:(id)callBackTargetMethod: (SEL)callBackSelectorMethod :(NSString*) playlistId;
-(void) callVideosServiceDone:(NSMutableDictionary*) responseDataDict;

@end
