//
//  TwitterItemCell.m
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterItemCell.h"
#import "TwitterTableItem.h"
#import "Constants.h"
#import "SharedObjects.h"

#define kTableCellVPadding 10
#define ipadVideoItemDim 65
#define iphoneVideoItemDim 48

@implementation TwitterItemCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {  
    
    CGFloat height = 0;
    
    TwitterTableItem *item = (TwitterTableItem*) object;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        CGSize textSize = [item.tweet sizeWithFont:kFontHelvetica22  
                                      constrainedToSize:CGSizeMake(620, 120)  
                                          lineBreakMode:UILineBreakModeWordWrap]; 
        
        height = kTableCellVPadding*2 + textSize.height + 110;
    }
    else {
        
        CGSize textSize = [item.tweet sizeWithFont:kFontHelvetica14  
                                      constrainedToSize:CGSizeMake(270, 80)  
                                          lineBreakMode:UILineBreakModeWordWrap];
        
        height = kTableCellVPadding*2 + textSize.height + 60;
    }  
    
    return height;
}  

///////////////////////////////////////////////////////////////////////////////////////////////////  

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {  
    if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {  
        _item = nil;  
        
        tweetLabel = [[IFTweetLabel alloc] initWithFrame:CGRectZero];
        tweetLabel.textColor = kFontColor;  
        tweetLabel.contentMode = UIViewContentModeTop;  
        tweetLabel.numberOfLines = 5;
        tweetLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:tweetLabel];
        
        detailTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        detailTextLabel.textColor = kFontColor;  
        detailTextLabel.textAlignment = UITextAlignmentLeft;  
        detailTextLabel.contentMode = UIViewContentModeTop;  
        detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;  
        detailTextLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:detailTextLabel];
        
        _imageView1 = [[TTImageView alloc] initWithFrame:CGRectZero];  
        _imageView1.style = [TTSolidFillStyle styleWithColor:[UIColor colorWithRed:10 green:15 blue:100 alpha:0.1] next:
                             [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:10.0f] next:
                              [TTContentStyle styleWithNext:nil]]];
        [self.contentView addSubview:_imageView1];  
        
        replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [replyButton setBackgroundImage:[UIImage imageNamed:@"reply_normal.png"] forState:UIControlStateNormal];
        [replyButton setBackgroundImage:[UIImage imageNamed:@"reply_clicked.png"] forState:UIControlStateSelected];
        //[replyButton setTitle:@"Reply" forState:UIControlStateNormal];
        //[replyButton setTitleColor:kFontColor forState:UIControlStateNormal];
        [replyButton setBackgroundColor:[UIColor clearColor]];
        [replyButton addTarget:self action:@selector(replyTweet) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:replyButton];
        
        retweetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        retweetButton.tag = kRetweetTag;
        [retweetButton setBackgroundImage:[UIImage imageNamed:@"retweet_normal.png"] forState:UIControlStateNormal];
        [retweetButton setBackgroundImage:[UIImage imageNamed:@"retweet_clicked.png"] forState:UIControlStateSelected];
        //[retweetButton setTitle:@"Retweet" forState:UIControlStateNormal];
        //[retweetButton setTitleColor:kFontColor forState:UIControlStateNormal];
        [retweetButton setBackgroundColor:[UIColor clearColor]];
        [retweetButton addTarget:self action:@selector(retweet) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:retweetButton]; 
    }  
    return self;  
}  

- (void)dealloc {  
    [tweetLabel release];
    [detailTextLabel release];
    TT_RELEASE_SAFELY(_imageView1);
    [super dealloc];  
}  
///////////////////////////////////////////////////////////////////////////////////////////////////  
// UIView  

- (void)layoutSubviews {  
    [super layoutSubviews];  
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    
        CGSize textSize = [tweetLabel.text sizeWithFont:kFontHelvetica22  
                                     constrainedToSize:CGSizeMake(620, 120)  
                                         lineBreakMode:UILineBreakModeWordWrap]; 
        
        _imageView1.frame = CGRectMake(10, 10, ipadVideoItemDim, ipadVideoItemDim);
        tweetLabel.frame = CGRectMake(90, 3, 610, textSize.height+20);
        detailTextLabel.frame = CGRectMake(90, tweetLabel.frame.origin.y+tweetLabel.frame.size.height+15, 500, 25);
        retweetButton.frame = CGRectMake(585, detailTextLabel.frame.origin.y+detailTextLabel.frame.size.height+10, 45, 45);
        replyButton.frame = CGRectMake(retweetButton.frame.origin.x+retweetButton.frame.size.width+20, retweetButton.frame.origin.y, 45, 45);
    }
    else {
       
        CGSize textSize = [tweetLabel.text sizeWithFont:kFontHelvetica14  
                                     constrainedToSize:CGSizeMake(270, 80)  
                                         lineBreakMode:UILineBreakModeWordWrap];  
        
        _imageView1.frame = CGRectMake(5, 5, iphoneVideoItemDim, iphoneVideoItemDim);
        tweetLabel.frame = CGRectMake(60, 3, 260, textSize.height+10);
        detailTextLabel.frame = CGRectMake(60, tweetLabel.frame.origin.y+tweetLabel.frame.size.height+10, 270, 20);
        retweetButton.frame = CGRectMake(225, detailTextLabel.frame.origin.y+detailTextLabel.frame.size.height+5, 25, 25);
        replyButton.frame = CGRectMake(retweetButton.frame.origin.x+retweetButton.frame.size.width+15, retweetButton.frame.origin.y, 25, 25);
    }
}  

- (void) retweet {

    TwitterTableItem* item = self.object;  

    [[NSNotificationCenter defaultCenter] postNotificationName:kTwitterShareNotification object:retweetButton 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:item.tweetId, @"tweetId", nil]];
}

- (void) replyTweet {

    TwitterTableItem* item = self.object;  

    if (nil != [[SharedObjects sharedInstance] tweetDetails]) {
        if ([[[SharedObjects sharedInstance] tweetDetails] count] > 0) {
            [[[SharedObjects sharedInstance] tweetDetails] removeAllObjects];
        }
    }
    
    [[[SharedObjects sharedInstance] tweetDetails] setObject:item.tweetId forKey:@"tweetId"];
    [[[SharedObjects sharedInstance] tweetDetails] setObject:[NSString stringWithFormat:@"@%@",item.username] forKey:@"tweetUser"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kreplyTweetNotification object:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////  
// TTTableViewCell  

- (id)object {  
    return _item;  
}  

- (void)setObject:(id)object {  
    if (_item != object) {  
        [super setObject:object];  
        
        TwitterTableItem* item = object;  
        
        tweetLabel.text = item.tweet;
        detailTextLabel.text = item.timeStamp;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            tweetLabel.font = kFontHelveticaBold22;
            detailTextLabel.font = kFontHelveticaBold22;
            detailTextLabel.numberOfLines = 1;
            replyButton.titleLabel.font = kFontHelvetica20;
            retweetButton.titleLabel.font = kFontHelvetica20;
        }
        else {
            tweetLabel.font = kFontHelveticaBold13;
            detailTextLabel.font = kFontHelveticaBold13;
            detailTextLabel.numberOfLines = 1;
            replyButton.titleLabel.font = kFontHelvetica13;
            retweetButton.titleLabel.font = kFontHelvetica13;
        }
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.profileImage]];

        if (data != nil && [data length] > 0) {
            [_imageView1 setDefaultImage:[UIImage imageWithData:data]];
        }
    }  
}  

@end
