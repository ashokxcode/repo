//
//  TwitterWebController.m
//  Celebrity
//
//  Created by charanya on 20/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterWebController.h"

@implementation TwitterWebController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundImage:[UIImage imageNamed:@"back_normal.png"]
//                      forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"back_clicked.png"]
//                      forState:UIControlStateHighlighted];	     
//    //set the frame of the button to the size of the image (see note below)
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        button.frame = CGRectMake(15, 10, 47, 47);
//    }
//    else {
//        button.frame = CGRectMake(10, 5, 30, 30);
//    }
//    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = barButton;
//    [barButton release];

    [self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void) back {

    if (self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    }
    
    return NO;
}

@end
