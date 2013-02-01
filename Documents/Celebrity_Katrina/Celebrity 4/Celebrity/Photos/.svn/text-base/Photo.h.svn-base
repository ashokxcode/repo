//
//  Photo.h
//  Three20PhotoGallery
//
//  Created by JayaPrathap Audikesavalu on 13/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface Photo : NSObject <TTPhoto> {
    NSString *_caption;
    NSString *_urlLarge;
    NSString *_urlThumb;
    id <TTPhotoSource> _photoSource;
    CGSize _size;
    NSInteger _index;
}

@property (nonatomic, copy) NSString *caption;
@property (nonatomic, copy) NSString *urlLarge;
@property (nonatomic, copy) NSString *urlThumb;
@property (nonatomic, assign) id <TTPhotoSource> photoSource;
@property (nonatomic) CGSize size;
@property (nonatomic) NSInteger index;

- (id)initWithCaption:(NSString *)caption urlLarge:(NSString *)urlLarge urlThumb:(NSString *)urlThumb size:(CGSize)size;

@end
