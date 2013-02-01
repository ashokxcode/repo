//
//  TableSubTitleItem.h
//  CelebrityApp
//
//  Created by JayaPrathap Audikesavalu on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface TableSubTitleItem : TTTableSubtitleItem {

    NSString *_title;
    NSString *_subTitle;
    NSString *_thumbImageUrl;
    NSString *_detailImageUrl;
    NSString *_url;
    
    NSMutableString *_createdDate;
    NSMutableString *_createdTime;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *thumbImageUrl;
@property (nonatomic, copy) NSString *detailImageUrl;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSMutableString *createdDate;
@property (nonatomic, copy) NSMutableString *createdTime;

+ (id)itemWithText:(NSString*)text 
          subtitle:(NSString*)subtitle 
          imageURL:(NSString*)imageURL
               URL:(NSString*)URL;

+ (id)itemWithText:(NSString*)text 
          subtitle:(NSString*)subtitle 
          thumbURL:(NSString*)thumbURL
          imageURL:(NSString*)imageUrl 
               URL:(NSString*)URL
              time:(NSMutableString*)createdTime
              date:(NSMutableString*)createdDate;

@end
