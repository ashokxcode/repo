//
//  Photo.m
//  Three20PhotoGallery
//
//  Created by JayaPrathap Audikesavalu on 13/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"

@implementation Photo

@synthesize caption = _caption;
@synthesize urlLarge = _urlLarge;
@synthesize urlThumb = _urlThumb;
@synthesize photoSource = _photoSource;
@synthesize size = _size;
@synthesize index = _index;

- (id)initWithCaption:(NSString *)caption urlLarge:(NSString *)urlLarge urlThumb:(NSString *)urlThumb size:(CGSize)size {
    
    if ((self = [super init])) {
        self.caption = caption;
        self.urlLarge = [urlLarge stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.urlThumb = [urlThumb stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.size = size;
        self.index = NSIntegerMax;
        self.photoSource = nil;
    }
    return self;
}

- (void) dealloc {
    
    // mem leak
    [_caption release];
    [_urlLarge release];
    [_urlThumb release];
    self.caption = nil;
    self.urlLarge = nil;
    self.urlThumb = nil;    
    
    [super dealloc];
}

#pragma mark TTPhoto

- (NSString*)URLForVersion:(TTPhotoVersion)version {
    switch (version) {
        case TTPhotoVersionLarge:
            return _urlLarge;
        case TTPhotoVersionMedium:
            return _urlLarge;
        case TTPhotoVersionThumbnail:
            return _urlThumb;
        default:
            return nil;
    }
}

@end
