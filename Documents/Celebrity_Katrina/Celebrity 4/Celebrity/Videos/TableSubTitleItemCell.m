//
//  TableSubTitleItemCell.m
//  CelebrityApp
//
//  Created by JayaPrathap Audikesavalu on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableSubTitleItemCell.h"
#import "TableSubTitleItem.h"
#import "Constants.h"
#import "Videos.h"

#define kTableCellVPadding 10
#define ipadVideoItemDim 130
#define iphoneVideoItemDim 70

@implementation TableSubTitleItemCell

@synthesize fbButton;
@synthesize twtButton;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {  
    
    TableSubTitleItem* item = object;
    
    CGFloat height = 0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        CGSize textSize = [item.title sizeWithFont:kFontHelvetica22  
                                     constrainedToSize:CGSizeMake(700, 70)  
                                         lineBreakMode:UILineBreakModeWordWrap];  
        
        CGSize subtextSize = [item.subTitle sizeWithFont:kFontHelvetica22  
                                              constrainedToSize:CGSizeMake(700, 70) 
                                                  lineBreakMode:UILineBreakModeTailTruncation];  
        
        if ([item.title length] > 0) {
            
            if ([item.subTitle length] > 0) {
                
                height = kTableCellVPadding*2 + subtextSize.height + textSize.height + 100;
            }
            else {
            
                height = kTableCellVPadding*2 + textSize.height + 130;
            }
        }
    }
    else {
        
        CGSize textSize = [item.title sizeWithFont:kFontHelvetica14  
                                 constrainedToSize:CGSizeMake(290, 60)  
                                     lineBreakMode:UILineBreakModeWordWrap];  
        
        CGSize subtextSize = [item.subTitle sizeWithFont:kFontHelvetica13  
                                       constrainedToSize:CGSizeMake(290, 40) 
                                           lineBreakMode:UILineBreakModeTailTruncation];  
        
        if ([item.title length] > 0) {
            
            if ([item.subTitle length] > 0) {
                
                height = kTableCellVPadding*2 + subtextSize.height + textSize.height + 45;
            }
            else {
                
                height = kTableCellVPadding*2 + textSize.height + 55;
            }
        }
    }  

    return height;
}  

///////////////////////////////////////////////////////////////////////////////////////////////////  

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {  
    if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {  
        _item = nil;  
        
        textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.textColor = kFontColor;  
        textLabel.textAlignment = UITextAlignmentLeft;  
        textLabel.contentMode = UIViewContentModeTop;  
        textLabel.lineBreakMode = UILineBreakModeWordWrap;  
        textLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:textLabel];

        detailTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        detailTextLabel.textColor = kSubFontColor;  
        detailTextLabel.textAlignment = UITextAlignmentLeft;  
        detailTextLabel.contentMode = UIViewContentModeTop;  
        detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;  
        detailTextLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:detailTextLabel];

        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_webView];
        
        fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
        fbButton.frame = CGRectZero;
        [fbButton setBackgroundImage:[UIImage imageNamed:@"fbButton.png"] forState:UIControlStateNormal];
        [fbButton setBackgroundColor:[UIColor clearColor]];
        fbButton.tag = kVideoShareTag;
        [fbButton addTarget:self action:@selector(shareThis) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:fbButton];
        
        twtButton = [UIButton buttonWithType:UIButtonTypeCustom];
        twtButton.frame = CGRectZero;
        [twtButton setBackgroundImage:[UIImage imageNamed:@"twitterButton.png"] forState:UIControlStateNormal];
        twtButton.tag = kVideoTweetTag;
        [twtButton addTarget:self action:@selector(tweetThis) forControlEvents:UIControlEventTouchUpInside];
        [twtButton setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:twtButton];
    }  
    return self;  
}  

- (void)dealloc {  
    [textLabel release];
    [detailTextLabel release];
    TT_RELEASE_SAFELY(_webView);
    [super dealloc];  
}  

- (void) shareThis {

    [[NSNotificationCenter defaultCenter] postNotificationName:kshareVideoNotification 
                                                        object:self.fbButton 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.object,
                                                                kNotificationShareKey, nil]];
}

- (void) tweetThis {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ktweetVideoNotification 
                                                        object:self.twtButton 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.object,
                                                                kNotificationShareKey, nil]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////  
// UIView  

- (void)layoutSubviews {  
    [super layoutSubviews];  
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        CGSize textSize = [textLabel.text sizeWithFont:kFontHelvetica22  
                                     constrainedToSize:CGSizeMake(700, 70)  
                                         lineBreakMode:UILineBreakModeWordWrap];  
        
        CGSize subtextSize = [detailTextLabel.text sizeWithFont:kFontHelvetica22  
                                              constrainedToSize:CGSizeMake(700, 70) 
                                                  lineBreakMode:UILineBreakModeTailTruncation];  

        _webView.frame = CGRectMake(10, 10, ipadVideoItemDim, ipadVideoItemDim);
        
        textLabel.frame = CGRectMake(_webView.frame.size.width + 30, 5, 550, textSize.height+20);
        
        if (detailTextLabel.text > 0) {
            
            detailTextLabel.frame = CGRectMake(textLabel.frame.origin.x, 
                                               textLabel.frame.origin.y + textSize.height + 5, 
                                               550, subtextSize.height+20);

            fbButton.frame = CGRectMake(textLabel.frame.origin.x+textLabel.frame.size.width-80,
                                        detailTextLabel.frame.origin.y+detailTextLabel.frame.size.height+20, 45, 45);
            
            twtButton.frame = CGRectMake(fbButton.frame.origin.x+fbButton.frame.size.width+15, 
                                         fbButton.frame.origin.y, 45, 45); 
        }
        else {
             
            fbButton.frame = CGRectMake(textLabel.frame.origin.x+textLabel.frame.size.width-80,
                                        textLabel.frame.origin.y+textLabel.frame.size.height+120, 45, 45);
            
            twtButton.frame = CGRectMake(fbButton.frame.origin.x+fbButton.frame.size.width+10, 
                                         fbButton.frame.origin.y, 45, 45); 
        }
    }
    else {
        
        CGSize textSize = [textLabel.text sizeWithFont:kFontHelvetica14  
                                     constrainedToSize:CGSizeMake(290, 60)  
                                         lineBreakMode:UILineBreakModeWordWrap];  
        
        CGSize subtextSize = [detailTextLabel.text sizeWithFont:kFontHelvetica13  
                                              constrainedToSize:CGSizeMake(290, 40) 
                                                  lineBreakMode:UILineBreakModeTailTruncation];  

        _webView.frame = CGRectMake(5, 5, iphoneVideoItemDim, iphoneVideoItemDim);
        
        textLabel.frame = CGRectMake(_webView.frame.size.width + 20, 5, 195, textSize.height+10);
        
        if (detailTextLabel.text > 0) {

            detailTextLabel.frame = CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y + textSize.height + 5, 
                                               195, subtextSize.height+10);

            fbButton.frame = CGRectMake(_webView.frame.origin.x+_webView.frame.size.width+165, 
                                        detailTextLabel.frame.origin.y+detailTextLabel.frame.size.height+10, 25, 25);
            
            twtButton.frame = CGRectMake(fbButton.frame.origin.x+fbButton.frame.size.width+10, 
                                         fbButton.frame.origin.y, 25, 25); 
        }
        else {
        
            fbButton.frame = CGRectMake(_webView.frame.origin.x+_webView.frame.size.width+165, 
                                       textLabel.frame.origin.y+textLabel.frame.size.height+50, 25, 25);
            
            twtButton.frame = CGRectMake(fbButton.frame.origin.x+fbButton.frame.size.width+10, 
                                        fbButton.frame.origin.y, 25, 25); 
        }
    }
}  

///////////////////////////////////////////////////////////////////////////////////////////////////  
// TTTableViewCell  

- (id)object {  
    return _item;  
}  

- (void)setObject:(id)object {  
    if (_item != object) {  
        [super setObject:object];  
        
        TableSubTitleItem* item = object;  
        
        textLabel.text = item.title;
        detailTextLabel.text = item.subTitle;
        
        float dimension = 0.0;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            textLabel.font = kFontHelvetica22;
            detailTextLabel.font = kFontHelvetica22;
            textLabel.numberOfLines = 3;
            detailTextLabel.numberOfLines = 2;
            dimension = ipadVideoItemDim;
        }
        else {
            textLabel.font = kFontHelvetica14;
            detailTextLabel.font = kFontHelvetica13;
            textLabel.numberOfLines = 3;
            detailTextLabel.numberOfLines = 2;
            dimension = iphoneVideoItemDim;
        }

        NSMutableString *htmlString = [NSMutableString stringWithFormat:@"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = %f\"/></head>",dimension];
            
        [htmlString appendFormat:@"<body style=\"background:#F00;margin-top:0px;margin-left:0px\"><div><object width=\"%f\" height=\"%f\">", dimension, dimension];
            
        [htmlString appendFormat:@"<param name=\"movie\" value=\%@\"></param><param name=\"wmode\" value=\"transparent\"></param>",[item url]];
             
        [htmlString appendFormat:@"<embed src=\"%@\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"%f\" height=\"%f\"></embed>",[item url], dimension, dimension];
            
        [htmlString appendString:@"</object></div></body></html>"];
                                    
        [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:nil]];
    }  
}  

@end
