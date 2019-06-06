//
//  VDownloadingCenter.m
//  Spark
//
//  Created by Vincent on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VDownloadingCenter.h"
#import "VIdleTimerSwitch.h"

VDownloadingCenter* s_downloadingCenter;

@implementation VDownloadingCenter
@synthesize downloaderDictionary = _downloaderDictionary;
@synthesize disableIdleTimer;

- (id)init
{
    self = [super init];
    if (self) 
    {
        _downloaderDictionary = [[NSMutableDictionary alloc] init];
        _locker = [[NSRecursiveLock alloc] init];
        disableIdleTimer = NO;
    }
    return self;
}

- (void)dealloc
{
    [idleTimerKey release];
    [_downloaderDictionary release];
    [super dealloc];
}

+ (VDownloadingCenter*)sharedCenter
{
    @synchronized(s_downloadingCenter)
    {
        if (s_downloadingCenter == nil) 
        {
            s_downloadingCenter = [[VDownloadingCenter alloc] init];
        }
    }
    return s_downloadingCenter;
}

- (BOOL)addDownloader: (VDownloader*)downloader
{
    if ([downloader.url length] == 0) 
    {
        return NO;
    }
    [_locker lock];
    if ([self.downloaderDictionary objectForKey: downloader.url]) 
    {
        [_locker unlock];
        return YES;
    }
    [_downloaderDictionary setObject: downloader forKey: downloader.url];
    [_locker unlock];
    if (disableIdleTimer) 
    {
        [[VIdleTimerSwitch sharedSwitch] turnTimer: YES key: idleTimerKey];
    }
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(didOneDownloaderFinished:) name: VDownloaderFinishedNotification object: downloader];
    return [downloader start];
}

- (void)removeDownloader: (NSString*)url
{
    [_locker lock];
    [_downloaderDictionary removeObjectForKey: url];
    [_locker unlock];
}

- (void)setDisableIdleTimer: (BOOL)disable
{
    if (idleTimerKey == nil) 
    {
        idleTimerKey = [[[VIdleTimerSwitch sharedSwitch] generateOneSwitchKey] retain];
    }
    disableIdleTimer = disable;
}

- (void)didOneDownloaderFinished: (NSNotification*) notification
{
    VDownloader* downloader = (VDownloader*)notification.object;
    [[NSNotificationCenter defaultCenter] removeObserver: self name: VDownloaderFinishedNotification object:downloader];
    [_locker lock];
    [_downloaderDictionary removeObjectForKey: downloader.url];
    if (_downloaderDictionary.count == 0 && idleTimerKey && disableIdleTimer == YES) 
    {
        [[VIdleTimerSwitch sharedSwitch] turnTimer: NO key: idleTimerKey];
    }
    [_locker unlock];
    
}
@end
