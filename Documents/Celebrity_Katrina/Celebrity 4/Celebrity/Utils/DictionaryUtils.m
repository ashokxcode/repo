//
//  DictionaryUtils.m
//  CelebrityApp
//
//  Created by JayaPrathap Audikesavalu on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DictionaryUtils.h"

static DictionaryUtils *sharedDictionaryUtils = nil;

@implementation DictionaryUtils

- (id) init {
	self = [super init];	
	
	return self;
}

#pragma mark GADRequest

// Here we're creating a simple GADRequest and whitelisting the application
// for test ads. You should request test ads during development to avoid
// generating invalid impressions and clicks.
- (GADRequest *)createRequest {
    
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad.
    request.testing = NO;
    
    return request;
}

+ (DictionaryUtils *)sharedInstance {
    @synchronized(self) {
        if (sharedDictionaryUtils == nil) 
		{
			sharedDictionaryUtils= [[self alloc] init]; // assignment not done here
        }
    }
	
    return sharedDictionaryUtils;
}

- (void) dealloc
{
	[super dealloc];
}

- (NSString*) stringFromZeroOneInt:(int) aKey {
	return (aKey ? @"1" : @"0");
}

- (int) intFromBool:(BOOL) aKey {
	return (aKey ? 1 : 0);
}

- (NSNumber*) numberWithBool:(BOOL) aKey {
	return (aKey ? [NSNumber numberWithInt:1] :[NSNumber numberWithInt:0]);
}

-(BOOL) dict:(NSDictionary*)dict boolForKey:(id) aKey
{
    BOOL result = FALSE; 
    
	id <NSObject> obj = [dict objectForKey:aKey];
    
	if (obj) {
		
		SEL bv = @selector(boolValue);
        
		if ([obj respondsToSelector:bv]) {
			result = ([obj performSelector:bv] ? TRUE : FALSE);
		}			
        else if ([obj isKindOfClass:[NSString class]]) {
			
			result = ([(NSString *)obj caseInsensitiveCompare: @"TRUE"] == NSOrderedSame);
            
            if (!result) 
				result = ([(NSString *)obj caseInsensitiveCompare: @"YES"] == NSOrderedSame);
			
		}
	}
	
    return result;
}

-(int) dict:(NSDictionary*)dict intForKey:(id) aKey
{
    int result = 0; 
    id <NSObject> obj = [dict objectForKey:aKey];
    if (obj) {
        SEL iv = @selector(intValue);
        if ([obj respondsToSelector:iv])
            result = (int)[obj performSelector:iv];
	}
    return result;
}

-(BOOL) dict:(NSDictionary*)dict hasKey:(id) testKey
{
	if([dict respondsToSelector:@selector(objectForKey:)]) 
	{
		return ([dict objectForKey:testKey] != nil);
	}   
	
	return NO;
}

-(BOOL) dict:(NSDictionary*)dict hasNullForKey:(id) testKey
{
	if([dict respondsToSelector:@selector(objectForKey:)]) 
	{
		return ([[dict objectForKey:testKey] isEqual:[NSNull null]]);
	}
    
	return NO;
}

// case insensitive search
- (BOOL) isArrayContains:(NSMutableArray*) array :(NSString*) object {
    
    BOOL found = FALSE;
    
    for (NSString* str in array) {
        
        if ([str caseInsensitiveCompare:object] == NSOrderedSame) {
            found = TRUE;
            break;
        }
    }
    
    return found;
}

// case insensitive search
- (BOOL) isDictContains:(NSMutableDictionary*) dict :(NSString*) key {
    
    BOOL found = FALSE;
    
    NSArray *keys = [dict allKeys];
    
    for (NSString *str in keys) {
        
        if ([str caseInsensitiveCompare:key] == NSOrderedSame) {
            
            found = TRUE;
            break;
        }
    }
    
    return found;
}

-(UIButton*) createButtonWithNormalImg:(UIImage*) buttonImage 
                         selectedImage:(UIImage*) buttonSelectedImg 
                                 frame:(CGRect) frame
{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[button setFrame:frame];
	
	[button setBackgroundImage:buttonImage forState:UIControlStateNormal];
	
	[button setBackgroundImage:buttonSelectedImg forState:UIControlStateSelected];
	
	return button;
}

-(UIView *) loadingViewOnNativePages 
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    
    CGRect loadingViewRect = CGRectMake(screenRect.size.width/2 - 60, screenRect.size.height/2 - 45 - 49, 120, 90);
    
    CGRect mainViewRect = CGRectMake(0, 44, screenRect.size.width, screenRect.size.height - 49);
    
    UIView *mainView = [[UIView alloc] initWithFrame:mainViewRect];	
	
    mainView.backgroundColor = [UIColor clearColor];
    
	UIView *loadingView = [[DictionaryUtils sharedInstance] roundRectViewWithFrame:loadingViewRect andColorRed:0 blue:0 green:0 alpha:0.7];
    
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	
	spinner.frame = CGRectMake(loadingViewRect.size.width/2 - 10, loadingViewRect.size.height/2 - 10, 20, 20);
	
	[spinner startAnimating];
	
	spinner.hidden = NO;
    
	[loadingView addSubview:spinner];
	
	[spinner release];
    
	UILabel *label = [[UILabel alloc] init];
	
	label.frame = CGRectMake(30, 50, 100, 30);
	
	label.backgroundColor = [UIColor clearColor];
    
	[label setText:@"Loading..."];
	
	[label setTextColor:[UIColor whiteColor]];
	
	[loadingView addSubview:label];
	
	[label release];
    
    [mainView addSubview:loadingView];
    
	return [mainView autorelease];	
}

-(UIView*)roundRectViewWithFrame:(CGRect)rect 
                     andColorRed:(CGFloat)red 
                            blue:(CGFloat)blue 
                           green:(CGFloat)green 
                           alpha:(CGFloat)alpha {
	
	UIView *roundRect = [[UIView alloc] initWithFrame:rect];
	
	roundRect.backgroundColor = [UIColor colorWithRed:red green:blue blue:green alpha:alpha];
	
	[roundRect.layer setCornerRadius:5];
	
	roundRect.clipsToBounds = YES;
	
	return [roundRect autorelease];
}

- (CGSize)getTextSize:(NSString*)text constrainedToSize:(CGSize)size withFont:(UIFont*)font {
	
	CGSize textSize =  [text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
	return textSize;
}

-(void)presentModalView:(UIView*)view 
{   
	//now move the view down
	[self moveView:view
                  :0:480 :NO :0.4 :kNoAnimation];
    
	//animate it up now.
	[self moveView:view
                  :0:0 :YES :0.4 :kBeginAndCommitAnimation];
}

-(void)dismissModalView:(UIView*)view
{
	//animate view and remove it	
	[self moveView:view
                  :0:480: YES :0.4 :kBeginAndCommitAnimation];
	
    [view performSelector:@selector(removeFromSuperview)
               withObject:nil
               afterDelay:0.6];
}

//moves a view to any place....animated or not animated 
-(void) moveView:(UIView*)view: 
(float)xVal:
(float)yVal:
(BOOL)isAnimated: 
(float)duration: 
(int) transitionPhase
{
	
	
	if(isAnimated)
	{
		
		if (transitionPhase==kBeginAnimations || transitionPhase==kBeginAndCommitAnimation)
			[UIView beginAnimations:nil context:nil];
		
		[UIView setAnimationDuration:duration];
		view.frame = CGRectMake(xVal, 
								yVal, 
								view.frame.size.width, 
								view.frame.size.height);
		
		
		if (transitionPhase==kCommitAnimations|| transitionPhase==kBeginAndCommitAnimation)
			[UIView commitAnimations];
	}
	else{
		view.frame = CGRectMake(xVal, 
								yVal, 
								view.frame.size.width, 
								view.frame.size.height);
	}
	
	
}

@end
