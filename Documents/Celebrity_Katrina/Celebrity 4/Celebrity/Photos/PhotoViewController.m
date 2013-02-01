//
//  PhotoViewController.m
//  CelebrityApp
//
//  Created by JayaPrathap Audikesavalu on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoSource.h"
#import "Photo.h"
#import "Constants.h"
#import "SharedObjects.h"
#import "PhotoView.h"

@implementation PhotoViewController

- (void)loadView
{
    UIView *ContentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.view = ContentView;
	[ContentView release];
	self.view.opaque = YES;
    self.view.backgroundColor = [UIColor grayColor];
    
    [self loadPhotosView];
}

-(void)back {  

    if ([self.navigationController.navigationBar viewWithTag:129]) {
        [[self.navigationController.navigationBar viewWithTag:129] removeFromSuperview];
    }
    
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (PhotoView*)createPhotoView {
    
    return [[[PhotoView alloc] init] autorelease];
}


- (void) loadPhotosView {
    
    self.photoSource = [[SharedObjects sharedInstance] photoSource];
    
    self.navigationBarStyle = UIBarStyleBlack;

    CGRect screenFrame = [UIScreen mainScreen].bounds;
    self.view = [[[UIView alloc] initWithFrame:screenFrame] autorelease];
    
    CGRect innerFrame = CGRectMake(0, 0,
                                   screenFrame.size.width, screenFrame.size.height);
    _innerView = [[UIView alloc] initWithFrame:innerFrame];
    _innerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_innerView];
    
    UIImageView *backgroundTwitter = [[UIImageView alloc] init];
    backgroundTwitter.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    backgroundTwitter.image = [UIImage imageNamed:@"background.png"];
    [_innerView addSubview:backgroundTwitter];
    [backgroundTwitter release];
    
    _scrollView = [[TTScrollView alloc] initWithFrame:screenFrame];
    _scrollView.delegate = self;
    _scrollView.dataSource = self;
    _scrollView.rotateEnabled = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_innerView addSubview:_scrollView];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"picts_next_normal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"picts_next_over.png"] forState:UIControlStateSelected];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"picts_next_over.png"] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevButton setBackgroundImage:[UIImage imageNamed:@"picts_back_normal.png"] forState:UIControlStateNormal];
    [prevButton setBackgroundImage:[UIImage imageNamed:@"picts_back_over.png"] forState:UIControlStateSelected];
    [prevButton setBackgroundImage:[UIImage imageNamed:@"picts_back_over.png"] forState:UIControlStateHighlighted];
    [prevButton addTarget:self action:@selector(previousAction) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect toolbarFrame = CGRectZero;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        toolbarFrame = CGRectMake(0, 926, screenFrame.size.width, 98);
    }
    else {
        toolbarFrame = CGRectMake(0, 425, screenFrame.size.width, 55);
    }
    customToolbar = [[CustomToolbar alloc] initWithFrame:toolbarFrame];
    customToolbar.backgroundColor = [UIColor grayColor];
    [_innerView addSubview:customToolbar];
    
    UIButton *fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fbButton setBackgroundImage:[UIImage imageNamed:@"fbButton.png"] forState:UIControlStateNormal];
    [fbButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    fbButton.tag = 911;
    
    UIButton *twtButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [twtButton setBackgroundImage:[UIImage imageNamed:@"twitterButton.png"] forState:UIControlStateNormal];
    [twtButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    twtButton.tag = 109;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        prevButton.frame = CGRectMake(140, 20, 55, 45);
        nextButton.frame = CGRectMake(prevButton.frame.origin.x+prevButton.frame.size.width+100, 
                                      prevButton.frame.origin.y, 55, 45);
        fbButton.frame = CGRectMake(nextButton.frame.origin.x+nextButton.frame.size.width+100, 
                                    15, 55, 55);
        twtButton.frame = CGRectMake(fbButton.frame.origin.x+fbButton.frame.size.width+100, 
                                     fbButton.frame.origin.y, 55, 55);
    }
    else {
        prevButton.frame = CGRectMake(50, 8, 28, 27);
        nextButton.frame = CGRectMake(prevButton.frame.origin.x+prevButton.frame.size.width+35, 
                                      prevButton.frame.origin.y, 28, 27);
        fbButton.frame = CGRectMake(nextButton.frame.origin.x+nextButton.frame.size.width+40, 
                                    5, 36, 33);
        twtButton.frame = CGRectMake(fbButton.frame.origin.x+fbButton.frame.size.width+40, 
                                     fbButton.frame.origin.y, 36, 33);
    }
    
    [customToolbar addSubview:prevButton];
    [customToolbar addSubview:nextButton];
    [customToolbar addSubview:fbButton];
    [customToolbar addSubview:twtButton];
}

- (void)scrollView:(TTScrollView*)scrollView tapped:(UITouch*)touch {
    customToolbar.hidden = !customToolbar.hidden;
}

- (void)updateChrome {
    
    [self.navigationItem setHidesBackButton:YES];
    
    // Set the custom back button
    if (![self.navigationController.navigationBar viewWithTag:129]) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 129;
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
    
    if (_photoSource.numberOfPhotos < 2) {
        self.title = _photoSource.title;
        
    } else {
        self.title = @"";
    }
    
    if ([_photoSource numberOfPhotos] <= 1) {
        if ([[self photoSource] numberOfPhotos] == 0) {
            customToolbar.hidden = YES;
        }
    }
    
    prevButton.enabled = _centerPhotoIndex > 0;
    nextButton.enabled = _centerPhotoIndex >= 0 && _centerPhotoIndex < _photoSource.numberOfPhotos-1;
}

-(void)share:(id)sender {
    
    if (nil != sender) {
        
        UIButton *button = (UIButton*)sender;
        
        if (button.tag == 911) {
            
            NSString *url1 = [_centerPhoto URLForVersion:TTPhotoVersionLarge];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kFaceBookShareNotification 
                                                                object:url1];

        }
        else if (button.tag == 109) {
        
            NSString *url2 = [_centerPhoto URLForVersion:TTPhotoVersionLarge];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kTwitterShareNotification 
                                                                object:url2];
        }
    }
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

    if (nil != customToolbar) [customToolbar release];

    [super dealloc];
}

@end
