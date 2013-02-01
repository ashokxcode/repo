//
//  DragDropViewController.h
//  Celebrity
//
//  Created by charanya on 12/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "BackgroundView.h"
#import "PieceView.h"
#import "AudioFX.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

#define kPuzzleSize				(IS_IPAD?762:320)
#define kNumPieces				5
#define kPieceSize				(IS_IPAD?230:96)
#define kPieceDistance			(IS_IPAD?152:62)//(kPuzzleSize / kNumPieces) == 154,64
#define kPieceShadowFactor		(IS_IPAD?2:4)
#define kPieceShadowOpacity		0.5
#define kPieceShadowOffset		1
#define kPieceGrabOffset		(IS_IPAD?5:3)
#define kPieceListMargin		(IS_IPAD?35:20)
#define kTransitionDuration		0.75

#define kPuzzleFrameRect        (IS_IPAD?CGRectMake(5, 28, kPuzzleSize, kPuzzleSize):CGRectMake(5, 10, kPuzzleSize, kPuzzleSize))

@interface DragDropViewController : UIViewController {

    BackgroundView*		_backgroundView;
	UIView*				_puzzleView;
	UIScrollView*		_scrollView;
	ViewController*		_viewController;
	PieceView*			_pieces[kNumPieces * kNumPieces];
    
	UIImageView*		_imageView;
	AudioFX*			_startSound;
	AudioFX*			_completedSound;
	AudioFX*			_dragSound;
	AudioFX*			_dropSound;
	AudioFX*			_snapSound;
	CGFloat				_puzzleRotation;
	BOOL				_completed;
	NSMutableArray*		_puzzles;
	
	CGPoint				_startLocation,
    _startPosition;
	BOOL				_didMove;
    
    int                 lastSelectedIndex;
}

- (void) willAnimateFirstHalfOfRotationFromOrientation:(UIInterfaceOrientation)fromOrientation toOrientation:(UIInterfaceOrientation)toOrientation;
- (void) willAnimateSecondHalfOfRotationFromOrientation:(UIInterfaceOrientation)fromOrientation toOrientation:(UIInterfaceOrientation)toOrientation;

- (void) resetPiece:(PieceView*)piece;
- (void) beginTrackingPiece:(PieceView*)piece position:(CGPoint)position;
- (void) continueTrackingPiece:(PieceView*)piece position:(CGPoint)position;
- (void) endTrackingPiece:(PieceView*)piece position:(CGPoint)position;

- (void) doubleTapBackground;
- (void) showHint;

@end
