//
//  DragDropViewController.m
//  Celebrity
//
//  Created by charanya on 12/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <mach/mach_time.h>

#import "DragDropViewController.h"

//MACROS:

#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
#define RANDOM_SEED() srandom((unsigned)(mach_absolute_time() & 0xFFFFFFFF))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__) - (__MIN__)))

//CLASS INTERFACES:

@interface DragDropViewController ()
- (void) _resetPuzzle;
@end

//VARIABLES:

static const CGFloat _OrientationAngles[] = {NAN, 0, 180, 90, 270, NAN, NAN};

//FUNCTIONS:

static CGAffineTransform _MakeRoundedRotationTransform(CGFloat angle)
{
	CGAffineTransform		transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(angle));
    
	//We need to "fix" the matrix to ensure it's a perfect rotation matrix if "angle" is a multiple of 90 degrees
	transform.a = roundf(transform.a);
    transform.b = roundf(transform.b);
    transform.c = roundf(transform.c);
    transform.d = roundf(transform.d);
	
	return transform;
}


@implementation DragDropViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

+ (void) initialize
{
	if(self == [DragDropViewController class])
        RANDOM_SEED();
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    lastSelectedIndex = 0;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tweets_title.png"] 
                                                  forBarMetrics:UIBarMetricsDefault];

    CGRect rect = [[UIScreen mainScreen] bounds];
    
    self.view.frame = rect;

    CGRect hintButtonFrame = CGRectZero;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        hintButtonFrame = CGRectMake(15, 10, 47, 47);
    }
    else {
        hintButtonFrame = CGRectMake(10, 5, 30, 30);
    }
    UIButton *hintButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hintButton setFrame:hintButtonFrame];
    [hintButton addTarget:self action:@selector(showHint) forControlEvents:UIControlEventTouchUpInside];
    [hintButton setBackgroundImage:[UIImage imageNamed:@"hint.png"] forState:UIControlStateNormal];
    [hintButton setBackgroundImage:[UIImage imageNamed:@"hint_over.png"] forState:UIControlStateHighlighted];
    [self.navigationController.navigationBar addSubview:hintButton];

    _viewController = [ViewController new];
    _viewController.proxy = self;
    [self.view addSubview:[_viewController view]];
    
    //Create the background transition view
	_backgroundView = [[BackgroundView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[_backgroundView setImage:[UIImage imageNamed:@"Puzzle-Background.png"]];
    _backgroundView.proxy = self;
	[_backgroundView setOpaque:YES];
    _backgroundView.userInteractionEnabled = YES;
	[self.view addSubview:_backgroundView];
	
	//Create the puzzle view and add it to the background view
	_puzzleView = [[UIView alloc] initWithFrame:kPuzzleFrameRect];
	[_backgroundView addSubview:_puzzleView];
	
	//Create the scrollview for the pieces and add it to the window
    CGRect scrollViewFrame = CGRectZero;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        scrollViewFrame = CGRectMake(0, kPuzzleSize-10, rect.size.width, rect.size.height-(kPuzzleSize-10));
    }
    else {
        scrollViewFrame = CGRectMake(0, kPuzzleSize, rect.size.width, rect.size.height-kPuzzleSize);
    }
	_scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
	[_scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Pieces-Background.png"]]];
	[_scrollView setCanCancelContentTouches:NO];
	[_scrollView setClipsToBounds:NO];
	[self.view addSubview:_scrollView];
	
	//Load sounds
	_startSound = [[AudioFX alloc] initWithPath:@"Start.mp3"];
	_completedSound = [[AudioFX alloc] initWithPath:@"Completed.mp3"];
	_dragSound = [[AudioFX alloc] initWithPath:@"Drag.caf"];
	_snapSound = [[AudioFX alloc] initWithPath:@"Snap.caf"];
	_dropSound = [[AudioFX alloc] initWithPath:@"Drop.caf"];
	//Reset the puzzle but with a delay to avoid blocking the UI while the app is still loading
	[self performSelector:@selector(_resetPuzzle) withObject:nil afterDelay:0.1];
}

- (void) viewWillAppear:(BOOL)animated {

    [self showHint];
}

- (void) showHint {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kat Puzzle" 
                                                    message:[NSString stringWithFormat:@"1. Drag & drop the pieces into game area to complete the pic.\n2. Double click on the game area to check for clue and come back.\n3. You can revert the move by double-clicking on the piece in the game area.\n4. After finishing the puzzle, double click game area for next puzzle. \n Happy playing!"] 
                                                   delegate:nil 
                                          cancelButtonTitle:@"Ok" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void) dealloc
{
	NSUInteger i;
	
	//[_puzzles release];
	
	[_dropSound release];
	[_startSound release];
	[_completedSound release];
	[_dragSound release];
	[_snapSound release];
	
	[_imageView release];
	for(i = 0; i < kNumPieces * kNumPieces; ++i)
        [_pieces[i] release];
	
	[_puzzleView release];
	[_scrollView release];
	[_backgroundView release];
	[_viewController release];
	
	[super dealloc];
}

- (void) _updatePieceList
{
	CGSize					size = [_scrollView bounds].size;
	NSArray*				subviews = [_scrollView subviews];
	NSUInteger				count = 0;
	PieceView*				view;
	
	//Reposition and count all pieces currently in scrollview
	for(view in subviews)
        if([view isKindOfClass:[PieceView class]]) {

            [view setCenter:CGPointMake(kPieceListMargin / 2 + kPieceSize / 2 + count * (kPieceSize + kPieceListMargin), (size.height / 2)-25)];
            ++count;
        }
	
	//Update the scrollview dimensions
	if(count * (kPieceSize + kPieceListMargin) > size.width) {
		[_scrollView setContentSize:CGSizeMake(count * (kPieceSize + kPieceListMargin), size.height)];
		[_scrollView setScrollEnabled:YES];
	}
	else {
		[_scrollView setContentSize:size];
		[_scrollView setScrollEnabled:NO];
	}
}

- (void) _resetPuzzle
{
	NSUInteger				indices[kNumPieces * kNumPieces];
	int     				index=0;
    NSUInteger              swap,i;
	UIImageView*			imageView;
	CGImageRef				image;
	CGImageRef				subImage;
	CGDataProviderRef		provider;
	CGContextRef			context;
	CGColorSpaceRef			imageColorSpace;
	CGColorSpaceRef			maskColorSpace;
	CGImageRef				mask;
	CGImageRef				tile;
	CGImageRef				shadow;
//	NSString*				path;
	CGAffineTransform		transform;
	
	//Reset puzzle state
	_completed = NO;
	
	//Pick a random puzzle orientation (1 out of 4 possibilities)
	_puzzleRotation = roundf(RANDOM_INT(0, 3) * 90.0);
	
	//Create our colorspaces
	imageColorSpace = CGColorSpaceCreateDeviceRGB();
	maskColorSpace = CGColorSpaceCreateDeviceGray();
	
	//Load a random puzzle image
    index = RANDOM_INT(1, 12);
    
    while (index == lastSelectedIndex) {
        index = RANDOM_INT(1, 12);
    }
    
    lastSelectedIndex = index;

    provider = CGDataProviderCreateWithFilename([[[NSBundle mainBundle] 
                                                  pathForResource:[NSString stringWithFormat:@"kat%d-ipad",lastSelectedIndex]
                                                  ofType:@"jpg"] UTF8String]);
    
	image = CGImageCreateWithJPEGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
	CGDataProviderRelease(provider);
//	[_puzzles removeObjectAtIndex:index];
	
	//Resize the puzzle image
	context = CGBitmapContextCreate(NULL, kPuzzleSize, kPuzzleSize, 8, 0, imageColorSpace, kCGImageAlphaPremultipliedFirst);
	CGContextDrawImage(context, kPuzzleFrameRect, image);
	CGImageRelease(image);
	image = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	//Create the image view with the puzzle image
	[_imageView release];
	_imageView = [[UIImageView alloc] initWithFrame:kPuzzleFrameRect];
	[_imageView setImage:[UIImage imageWithCGImage:image]];
	
	//Create the puzzle pieces (note that pieces are rotated to the puzzle orientation in order to minimize the number of graphic operations when creating the puzzle images)
	transform = _MakeRoundedRotationTransform(_puzzleRotation);
	for(i = 0; i < kNumPieces * kNumPieces; ++i) {
		//Recreate the piece view
		[_pieces[i] removeFromSuperview];
		[_pieces[i] release];
		_pieces[i] = [[PieceView alloc] initWithFrame:CGRectMake(0, 0, kPieceSize, kPieceSize) index:i];
		[_pieces[i] setTransform:transform];
        _pieces[i].proxy = self;
		[_pieces[i] setTag:-1];
		
		//Adjust the puzzle piece index according to puzzle orientation
		if((_puzzleRotation == 0) || (_puzzleRotation == 180))
            index = i;
		else
            index = kNumPieces - 1 - (i / kNumPieces) + (i % kNumPieces) * kNumPieces;
		if((_puzzleRotation == 180) || (_puzzleRotation == 90))
            index = kNumPieces * kNumPieces - 1 - index;
		
		//Load puzzle piece mask image
        provider = CGDataProviderCreateWithFilename([[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%02i", index + 1] ofType:@"png"] UTF8String]);
        //        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            provider = CGDataProviderCreateWithFilename([[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%02i-ipad", index + 1] ofType:@"png"] UTF8String]);
//        }
//        else {
//            
//        }
		tile = CGImageCreateWithPNGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
		CGDataProviderRelease(provider);
		mask = CGImageCreateCopyWithColorSpace(tile, maskColorSpace);
		CGImageRelease(tile);
		
		//Create image view with a low-resolution piece shadow image (to make it look blurred) and add it to the piece view
		context = CGBitmapContextCreate(NULL, kPieceSize / kPieceShadowFactor, kPieceSize / kPieceShadowFactor, 8, 0, imageColorSpace, kCGImageAlphaPremultipliedFirst);
		CGContextClipToMask(context, CGRectMake(0, 0, kPieceSize / kPieceShadowFactor, kPieceSize / kPieceShadowFactor), mask);
		CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
		CGContextFillRect(context, CGRectMake(0, 0, kPieceSize / kPieceShadowFactor, kPieceSize / kPieceShadowFactor));
		shadow = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kPieceSize, kPieceSize)];
		[imageView setImage:[UIImage imageWithCGImage:shadow]];
		[imageView setAlpha:kPieceShadowOpacity];
		[imageView setUserInteractionEnabled:NO];
		[_pieces[i] addSubview:imageView];
		[imageView release];
		CGImageRelease(shadow);
		
		//Create image view with piece image and add it to the piece view
		context = CGBitmapContextCreate(NULL, kPieceSize, kPieceSize, 8, 0, imageColorSpace, kCGImageAlphaPremultipliedFirst);
		if(_puzzleRotation) {
			CGContextTranslateCTM(context, kPieceSize / 2, kPieceSize / 2);
			CGContextRotateCTM(context, DEGREES_TO_RADIANS(_puzzleRotation));
			CGContextTranslateCTM(context, -kPieceSize / 2, -kPieceSize / 2);
		}
		CGContextTranslateCTM(context, (kPieceSize - kPieceDistance) / 2 - fmodf(i, kNumPieces) * kPieceDistance, (kPieceSize - kPieceDistance) / 2 - (kNumPieces - 1 - floorf(i / kNumPieces)) * kPieceDistance);
		CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
		subImage = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		tile = CGImageCreateWithMask(subImage, mask);
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kPieceSize, kPieceSize)];
		[imageView setImage:[UIImage imageWithCGImage:tile]];
		[imageView setUserInteractionEnabled:NO];
		[_pieces[i] addSubview:imageView];
		[imageView release];
		CGImageRelease(tile);
		CGImageRelease(subImage);
		
		//Release puzzle piece mask
		CGImageRelease(mask);
		
		//Make sure the shadow is setup correctly
		[_pieces[i] updateShadow:NO forRotation:_puzzleRotation];
	}
	
	//Clean up
	CGColorSpaceRelease(maskColorSpace);
	CGColorSpaceRelease(imageColorSpace);
	CGImageRelease(image);
	
	//Randomize pieces order
	for(i = 0; i < kNumPieces * kNumPieces; ++i)
        indices[i] = i;
	for(i = 0; i < 256; ++i) {
		index = RANDOM_INT(0, kNumPieces * kNumPieces - 1);
		swap = indices[index];
		indices[index] = indices[0];
		indices[0] = swap;
	}
	
	//Add all pieces to the scrollview
	for(i = 0; i < kNumPieces * kNumPieces; ++i)
        [_scrollView addSubview:_pieces[indices[i]]];
	[self _updatePieceList];
	
	//Play start sound
	[_startSound play];
}

- (void) doubleTapBackground
{
	//If the puzzle is completed, start a new one
	if(_completed)
        [self performSelector:@selector(_resetPuzzle) withObject:nil afterDelay:0.0];
	//Otherwise, toggle the visibility of the final image
	else {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:kTransitionDuration];
		[UIView setAnimationTransition:([_imageView superview] ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight) forView:_backgroundView cache:YES];
		if([_imageView superview]) {
			[_imageView removeFromSuperview];
			[_backgroundView addSubview:_puzzleView];
		}
		else {
			[_puzzleView removeFromSuperview];
			[_backgroundView addSubview:_imageView];
		}
		[UIView commitAnimations];
	}
}

- (void) resetPiece:(PieceView*)piece
{
	CGFloat	angle = _OrientationAngles[[_viewController interfaceOrientation]];
    
	//If the piece is not in the scrollview, put it back there
	if([piece superview] != _scrollView) {
		//Move the piece from puzzle view to scrollview
		[piece setTag:-1];
		[piece removeFromSuperview];
		[piece setTransform:_MakeRoundedRotationTransform(angle + _puzzleRotation)];
		[piece setCenter:[_scrollView convertPoint:[piece center] fromView:_puzzleView]];
		[_scrollView insertSubview:piece atIndex:MIN(ceilf([_scrollView contentOffset].x / (kPieceSize + kPieceListMargin)), [[_scrollView subviews] count])];
		
		//Update pieces in scrollview
		[UIView beginAnimations:nil context:NULL];
		[self _updatePieceList];
		[UIView commitAnimations];
		
		//Play sound
		[_dragSound play];
	}
}

- (void) beginTrackingPiece:(PieceView*)piece position:(CGPoint)position
{
	//Save initial position and prepare tracking
	_startLocation = [[piece superview] convertPoint:position fromView:piece];
	_startPosition = [piece center];
	[[piece superview] bringSubviewToFront:piece];
	_didMove = NO;
	
	//Update shadow
	[piece updateShadow:YES forRotation:_puzzleRotation];
	
	//Reset position tag
	[piece setTag:-1];
}

- (void) continueTrackingPiece:(PieceView*)piece position:(CGPoint)position
{
	CGPoint	location = [[piece superview] convertPoint:position fromView:piece];
	CGRect	bounds;
	
	//Update piece position
	location.x = _startPosition.x + location.x - _startLocation.x;
	location.y = _startPosition.y + location.y - _startLocation.y;
	
	//Make sure piece stays inside puzzle view
	if([piece superview] == _puzzleView) {
		bounds = [_puzzleView bounds];
		location.x = MIN(MAX(bounds.origin.x, location.x), bounds.origin.x + bounds.size.width);
		location.y = MIN(MAX(bounds.origin.y, location.y), bounds.origin.y + bounds.size.height);
	}
	
	//Move piece
	[piece setCenter:location];
	
	//Play sound
	if((_didMove == NO) && ([piece superview] != _puzzleView))
        [_dragSound play];
	_didMove = YES;
}

- (void) endTrackingPiece:(PieceView*)piece position:(CGPoint)position
{
	BOOL					snap = NO;
	CGPoint					snapPosition;
	NSInteger				index;
	NSUInteger				i;
	
	//Make sure the piece has actually moved
	if(_didMove) {
		//If the piece is in the scrollview, check if if needs to be moved out of it into the puzzle view or if it needs to slide back into place
		if([piece superview] != _puzzleView) {
			if([_imageView superview] || CGRectContainsPoint([_scrollView bounds], [[piece superview] convertPoint:position fromView:piece])) {
				[UIView beginAnimations:nil context:NULL];
				[piece setCenter:_startPosition];
				[UIView commitAnimations];
				
				[_dragSound play];
			}
			else {
				[piece removeFromSuperview];
				[piece setTransform:_MakeRoundedRotationTransform(_puzzleRotation)];
				[piece setCenter:[_puzzleView convertPoint:[piece center] fromView:_scrollView]];
				[_puzzleView addSubview:piece];
				
				[UIView beginAnimations:nil context:NULL];
				[self _updatePieceList];
				[UIView commitAnimations];
			}
		}
		
		//If the piece is in the puzzle view, check if it can "snap" into a known piece position
		if([piece superview] == _puzzleView) {
			position = [piece center];
			snapPosition.x = MIN(MAX(roundf((position.x - kPieceDistance / 2) / kPieceDistance), 0), kNumPieces - 1);
			snapPosition.y = MIN(MAX(roundf((position.y - kPieceDistance / 2) / kPieceDistance), 0), kNumPieces - 1);
			index = snapPosition.y * kNumPieces + snapPosition.x;
			snapPosition.x = snapPosition.x * kPieceDistance + kPieceDistance / 2;
			snapPosition.y = snapPosition.y * kPieceDistance + kPieceDistance / 2;
			
			snap = YES;
			for(i = 0; snap && (i < kNumPieces * kNumPieces); ++i) {
				if((_pieces[i] != piece) && ([_pieces[i] tag] == index))
                    snap = NO;
				
				if((index % kNumPieces >= 1) && ([_pieces[i] tag] == index - 1)) {
					if(i != [piece index] - 1)
                        snap = NO;
				}
				
				if((index % kNumPieces < kNumPieces - 1) && ([_pieces[i] tag] == index + 1)) {
					if(i != [piece index] + 1)
                        snap = NO;
				}
				
				if((index / kNumPieces >= 1) && ([_pieces[i] tag] == index - kNumPieces)) {
					if(i != [piece index] - kNumPieces)
                        snap = NO;
				}
				
				if((index / kNumPieces < kNumPieces - 1) && ([_pieces[i] tag] == index + kNumPieces)) {
					if(i != [piece index] + kNumPieces)
                        snap = NO;
				}
			}
			
			if(snap) {
				[piece setTag:index];
				[UIView beginAnimations:nil context:NULL];
				[piece setCenter:snapPosition];
				[UIView commitAnimations];
			}
			
			if(snap)
                [_snapSound play];
			else
                [_dropSound play];
		}
	}
	
	//Update piece shadow with animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.1];
	[piece updateShadow:NO forRotation:_puzzleRotation];
	[UIView commitAnimations];
	
	//If the piece was snapped, check if the puzzle is now completed
	if(snap) {
		for(i = 0; i < kNumPieces * kNumPieces; ++i)
            if([_pieces[i] tag] != [_pieces[i] index]) {
                snap = NO;
                break;
            }
		if(snap) {
			[_completedSound play];
			
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Congratulations!" 
                                                            message:[NSString stringWithFormat:@"You have successfully completed the Jigsaw puzzle. Tap twice on the completed puzzle to play again."] 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil];
            [alert1 show];
            [alert1 release];
            
			//Disable interaction with all pieces
			_completed = YES;
            for(i = 0; i < kNumPieces * kNumPieces; ++i)
               [_pieces[i] setUserInteractionEnabled:NO];
		}
	}
}

- (void) willAnimateFirstHalfOfRotationFromOrientation:(UIInterfaceOrientation)fromOrientation toOrientation:(UIInterfaceOrientation)toOrientation
{
	CGFloat	angle = _OrientationAngles[fromOrientation] + (_OrientationAngles[toOrientation] - _OrientationAngles[fromOrientation]) / 2.0;
	CGAffineTransform		transform;
	NSUInteger				i;
	
	//Half-rotate background view
	transform = _MakeRoundedRotationTransform(angle);
	[_backgroundView setTransform:transform];
	
	//Half-rotate all pieces in the scrollview
	transform = _MakeRoundedRotationTransform(angle + _puzzleRotation);
	for(i = 0; i < kNumPieces * kNumPieces; ++i) {
		if([_pieces[i] superview] == _scrollView)
            [_pieces[i] setTransform:transform];
	}
}

- (void) willAnimateSecondHalfOfRotationFromOrientation:(UIInterfaceOrientation)fromOrientation toOrientation:(UIInterfaceOrientation)toOrientation
{
	CGFloat					angle = _OrientationAngles[toOrientation];
	CGAffineTransform		transform;
	NSUInteger				i;
	
	//Rotate background view
	transform = _MakeRoundedRotationTransform(angle);
	[_backgroundView setTransform:transform];
	
	//Rotate all pieces in the scrollview
	transform = _MakeRoundedRotationTransform(angle + _puzzleRotation);
	for(i = 0; i < kNumPieces * kNumPieces; ++i) {
		if([_pieces[i] superview] == _scrollView)
            [_pieces[i] setTransform:transform];
	}
}

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
