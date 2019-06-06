//
//  VUIImageItem.m
//  Spark
//
//  Created by Vincent on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VUIImageItem.h"

@implementation VUIImageItem
@synthesize image;
@synthesize indexPath;
@synthesize url;
@synthesize downloader;
@synthesize userData;

- (void)dealloc
{
    self.image = nil;
    self.indexPath = nil;
    self.url = nil;
    self.downloader = nil;
    self.userData = nil;
    [super dealloc];
}

@end
