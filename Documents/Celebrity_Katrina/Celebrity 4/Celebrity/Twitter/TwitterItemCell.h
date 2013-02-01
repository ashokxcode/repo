//
//  TwitterItemCell.h
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "IFTweetLabel.h"

@interface TwitterItemCell : TTTableSubtitleItemCell {

    TTImageView* _imageView1;
    IFTweetLabel *tweetLabel;
    UILabel *detailTextLabel;
    UIButton *replyButton;
    UIButton *retweetButton;
}

@end
