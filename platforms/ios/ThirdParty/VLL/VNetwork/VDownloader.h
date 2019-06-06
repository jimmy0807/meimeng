//
//  VDownloader.h
//  Spark
//
//  Created by Vincent on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VDownloaderStatusInvalid,
    VDownloaderStatusDownloading,
    VDownloaderStatusPaused,
    VDownloaderStatusDownloaded,
    VDownloaderStatusCancelled,
    VDownloaderStatusFailedWithNetworkError,
    VDownloaderStatusFailedWithOutputError,
    VDownloaderStatusFailedWithServerError,
}VDownloaderStatus;

#define VDownloaderFinishedNotification @"VDownloaderFinishedNotification"
#define VDownloaderProgressNotification @"VDownloaderProgressNotification"

#define VDownloaderStatusKey @"status"
#define VDownloaderUrlKey   @"url"
#define VDownloaderAdditional @"additional"

#define VDownloaderReceivedBytesKey @"receivedBytes"
#define VDownloaderTotalBytesKey @"totalBytes"

@interface VDownloader : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSOutputStream* outputStream;
    NSURLConnection* _connection;
    NSString* cachePath;
    NSString* urlHash;
}

+ (NSString*)defaultCachePathForUrl: (NSString*)aUrl;

- (id)initWithUrlString: (NSString*)aUrl;
- (id)initWithUrlString: (NSString*)url filePath: (NSString*)filePath;

@property(nonatomic, copy) NSString* url;
@property(nonatomic, copy) NSString* filePath;
@property(nonatomic, retain) NSDictionary* httpHeaders;
@property(nonatomic, retain) NSHTTPURLResponse* httpResponse;
@property(nonatomic, assign) VDownloaderStatus downloadingStatus;
@property(nonatomic, copy) NSString* cachePath;
@property(nonatomic, retain)id userData;

@property(nonatomic, assign) BOOL isSiteSupportResume;
@property(nonatomic, assign) BOOL cacheAtOtherPlace;
@property(nonatomic, assign) BOOL needProgressNotifications;
@property(nonatomic, assign) NSInteger retryTimes;

@property(nonatomic, assign, readonly) unsigned long long receivedBytes;
@property(nonatomic, assign, readonly) unsigned long long totalBytes;

- (void)reset;
- (BOOL)start;
- (void)cancel;
- (void)clearCache;
- (void)pause;

@end
