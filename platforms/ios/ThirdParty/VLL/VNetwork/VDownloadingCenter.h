//
//  VDownloadingCenter.h
//  Spark
//
//  Created by Vincent on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDownloader.h"
#import "VUIImageItem.h"

@interface VDownloadingCenter : NSObject
{
    NSMutableDictionary* _downloaderDictionary;
    NSRecursiveLock* _locker;
    NSString* idleTimerKey;
}

- (BOOL)addDownloader: (VDownloader*)downloader;
- (void)removeDownloader: (NSString*)url;
+ (VDownloadingCenter*)sharedCenter;

@property(nonatomic, retain, readonly) NSDictionary* downloaderDictionary;
@property(nonatomic, assign) BOOL disableIdleTimer;
@end
