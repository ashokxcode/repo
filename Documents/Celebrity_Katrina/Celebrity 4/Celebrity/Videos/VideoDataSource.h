//
//  VideoDataSource.h
//  CelebrityApp
//
//  Created by JayaPrathap Audikesavalu on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface VideoDataSource : TTListDataSource {

}

+ (VideoDataSource*)rootViewDataSource;
+ (VideoDataSource*)playListDataSource;

@end
