//
//  DictionaryUtils.h
//  CelebrityApp
//
//  Created by JayaPrathap Audikesavalu on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADRequest.h"

#define kBeginAnimations 0
#define kAddAnimation 1
#define kCommitAnimations 2
#define kBeginAndCommitAnimation  3
#define kNoAnimation  4
#define kLoadingIndicatorOnNativePages 555

@class GADRequest;

@interface DictionaryUtils : NSObject {
    
}

-(GADRequest *)createRequest;

+ (DictionaryUtils *)sharedInstance;
- (NSString*) stringFromZeroOneInt:(int) aKey;
- (int) intFromBool:(BOOL) aKey;
- (NSNumber*) numberWithBool:(BOOL) aKey;
- (BOOL) dict:(NSDictionary*)dict boolForKey:(id) aKey;
- (int) dict:(NSDictionary*)dict intForKey:(id) aKey;
- (BOOL) dict:(NSDictionary*)dict hasKey:(id) testKey;
- (BOOL) dict:(NSDictionary*)dict hasNullForKey:(id) testKey;

- (BOOL) isArrayContains:(NSMutableArray*) array :(NSString*) object;
- (BOOL) isDictContains:(NSMutableDictionary*) dict :(NSString*) key;

-(UIButton*) createButtonWithNormalImg:(UIImage*) buttonImage 
                         selectedImage:(UIImage*) buttonSelectedImg 
                                 frame:(CGRect) frame;

-(UIView *) loadingViewOnNativePages;

-(UIView*)roundRectViewWithFrame:(CGRect)rect 
                     andColorRed:(CGFloat)red 
                            blue:(CGFloat)blue 
                           green:(CGFloat)green 
                           alpha:(CGFloat)alpha;

-(CGSize)getTextSize:(NSString*)text constrainedToSize:(CGSize)size withFont:(UIFont*)font;

-(void)presentModalView:(UIView*)view;

-(void)dismissModalView:(UIView*)view;

-(void) moveView:(UIView*)view: 
    (float)xVal:
    (float)yVal:
    (BOOL)isAnimated: 
    (float)duration: 
    (int) transitionPhase;

@end
