//
//  PhotoViewController.h
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 02/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "CustomToolbar.h"

@interface PhotoViewController : TTPhotoViewController <UIActionSheetDelegate> {

    CustomToolbar *customToolbar;
    UIButton *nextButton;
    UIButton *prevButton;
}

- (void) loadPhotosView;

@end
