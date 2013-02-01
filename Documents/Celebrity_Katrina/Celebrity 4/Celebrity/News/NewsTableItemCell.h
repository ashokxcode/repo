//
//  NewsTableItemCell.h
//  CelebrityApp
//
//  Created by JayaPrathap Audikesavalu on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface NewsTableItemCell : TTTableSubtitleItemCell {

    TTImageView* _imageView1;
    UILabel *textLabel;
    
    UIButton *fbButton;
    UIButton *twtButton;
}

@property (nonatomic, retain) UIButton *fbButton;
@property (nonatomic, retain) UIButton *twtButton;

@end
