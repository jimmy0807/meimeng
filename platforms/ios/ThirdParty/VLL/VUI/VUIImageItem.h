//
//  VUIImageItem.h
//  Spark
//
//  Created by Vincent on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDownloader.h"

@interface VUIImageItem : NSObject

@property(nonatomic, retain) UIImage* image;
@property(nonatomic, copy) NSString* url;
@property(nonatomic, retain) NSIndexPath* indexPath;
@property(nonatomic, retain) VDownloader* downloader;
@property(nonatomic, retain) NSObject* userData;

@end
