//
//  CustomToolbar.m
//  Celebrity
//
//  Created by charanya on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomToolbar.h"

@implementation CustomToolbar

- (void)drawRect:(CGRect)rect {
    
    UIImage *backgroundImage = [UIImage imageNamed:@"picts_bar.png"];
    [backgroundImage drawInRect:rect];
}

@end
