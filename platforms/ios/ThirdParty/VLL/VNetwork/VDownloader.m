//
//  VDownloader.m
//  Spark
//
//  Created by Vincent on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VDownloader.h"
#import "VUtil.h"
#import "NSData+Additions.h"

@interface VDownloader ()
- (void)postFinishNotificationWithStatus: (VDownloaderStatus)status; 
- (void)retry;
- (BOOL)startSendRequest;
- (void)closeOutputStream;
@end

@implementation VDownloader
@synthesize url;
@synthesize filePath;
@synthesize httpHeaders;
@synthesize httpResponse;
@synthesize isSiteSupportResume;
@synthesize downloadingStatus;
@synthesize cacheAtOtherPlace;
@synthesize cachePath;
@synthesize needProgressNotifications;
@synthesize receivedBytes;
@synthesize totalBytes;
@synthesize retryTimes;
@synthesize userData;

- (id)initWithUrlString: (NSString*)aUrl filePath: (NSString*)aFilePath
{
    self = [super init];
    if (self) 
    {
        self.url = aUrl;
        self.filePath = aFilePath;
        self.retryTimes = 2;
        self.cacheAtOtherPlace = YES;
        NSData* data = [aUrl dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion: YES];
        urlHash = [[data sha1Hash] copy];
    }
    return self;
}

- (id)initWithUrlString: (NSString*)aUrl
{
    self = [super init];
    if (self) 
    {
        self.url = aUrl;
        NSString* path = [VUtil cachePath];
        NSData* data = [aUrl dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion: YES];
        urlHash = [[data sha1Hash] copy];
        self.filePath = [path stringByAppendingPathComponent: urlHash];
        self.cacheAtOtherPlace = YES;
        self.retryTimes = 2;
    }
    return self;
}

- (void)dealloc
{
    if (_connection) 
    {
        [_connection cancel];
        SAFE_RELEASE(_connection);
    }
    [urlHash release];
    [self closeOutputStream];
    self.url = nil;
    self.filePath = nil;
    self.httpResponse = nil;
    self.httpHeaders = nil;
    self.cachePath = nil;
    self.userData = nil;
    [super dealloc];
}

- (void)reset
{
    if (_connection) 
    {
        [_connection cancel];
        SAFE_RELEASE(_connection);
    }
    receivedBytes = 0;
    [self closeOutputStream];
    [self clearCache];
}

- (BOOL)startSendRequest
{
    if (_connection) 
    {
        return YES;
    }
    if ([self.url length] == 0 || [self.filePath length] == 0) 
    {
        return NO;
    }
    if (self.cacheAtOtherPlace) 
    {
        if ([self.cachePath length] == 0) 
        {
            NSString* cacheDir = [[VUtil cachePath] stringByAppendingPathComponent: @"vtemp"];
            self.cachePath = [cacheDir stringByAppendingPathComponent: urlHash];
            BOOL isDir;
            if (![[NSFileManager defaultManager] fileExistsAtPath: cacheDir isDirectory: &isDir]) 
            {
                [[NSFileManager defaultManager] createDirectoryAtPath: cacheDir withIntermediateDirectories: YES attributes: nil error: nil];
            }
            else 
            {
                if (!isDir) 
                {
                    for (NSInteger i = 1 ; ; ++i) 
                    {
                        NSString* renamed = [cacheDir stringByAppendingFormat: @"-%d", i];
                        if (![[NSFileManager defaultManager] fileExistsAtPath: renamed]) 
                        {
                            [[NSFileManager defaultManager] moveItemAtPath: cacheDir toPath:renamed error: nil];
                            break;
                        }
                    }
                    [[NSFileManager defaultManager] createDirectoryAtPath: cacheDir withIntermediateDirectories: YES attributes: nil error: nil];
                }
            }
            
        }
    }
    else 
    {
        self.cachePath = self.filePath;
    }
    downloadingStatus = VDownloaderStatusDownloading;
    if (outputStream == nil) 
    {
        outputStream = [[NSOutputStream outputStreamToFileAtPath: self.cachePath append: NO] retain];
        [outputStream open];        
    }
    NSURLRequest* rq = [NSURLRequest requestWithURL: [NSURL URLWithString: self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval: 30];
    _connection = [[NSURLConnection connectionWithRequest: rq delegate: self] retain];
    [_connection start];
    return YES;
}

- (BOOL)start
{
    if ([self startSendRequest]) 
    {
        [self retain]; 
        return YES;
    }
    return  NO;
}

- (void)cancel
{
    if (downloadingStatus == VDownloaderStatusDownloading || downloadingStatus == VDownloaderStatusPaused)
    {
        [self reset];
        downloadingStatus = VDownloaderStatusCancelled;
        [self postFinishNotificationWithStatus: downloadingStatus];
    }
}

- (void)pause
{
    if (!isSiteSupportResume) 
    {
        [self cancel];
    }
    else 
    {
        if (_connection) 
        {
            [_connection cancel];
            SAFE_RELEASE(_connection);
        }       
    }
    downloadingStatus = VDownloaderStatusPaused;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self closeOutputStream];
    SAFE_AUTORELEASE(_connection);
    if (!isSiteSupportResume) 
    {
        [self clearCache];
    }
    if (self.retryTimes > 0) 
    {
        retryTimes --;
        [self retry];
    }
    else 
    {
        downloadingStatus = VDownloaderStatusFailedWithNetworkError;
        [self postFinishNotificationWithStatus: downloadingStatus];        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response isKindOfClass: [NSHTTPURLResponse class]])
    {
        self.httpResponse = (NSHTTPURLResponse*)response;
    }

    //NSLog(@"VDownloader: response: %d", self.httpResponse.statusCode);
    totalBytes = response.expectedContentLength;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSUInteger len = [data length];
    NSUInteger remain = len;
    while (remain > 0)
    {
        NSData* subData = data;
        if (remain != len) 
        {
            subData = [data subdataWithRange: NSMakeRange(len - remain, remain)];
        }
        NSInteger writeThisTime = [outputStream write: [subData bytes] maxLength: [subData length]];
        if (writeThisTime < 0) 
        {
            // Failed!!
            if (![outputStream hasSpaceAvailable]) 
            {
                
            }
            [_connection cancel];
            SAFE_AUTORELEASE(_connection);
            [self closeOutputStream];
            [self clearCache];
            downloadingStatus = VDownloaderStatusFailedWithOutputError;
            [self postFinishNotificationWithStatus: downloadingStatus];
            return;
        }
        remain -= writeThisTime;
    }
    receivedBytes += len;
    if (self.needProgressNotifications) 
    {
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys: 
                              self.url, VDownloaderUrlKey
                              , [NSNumber numberWithInteger: receivedBytes], VDownloaderReceivedBytesKey
                              , [NSNumber numberWithInteger: totalBytes], VDownloaderTotalBytesKey
                              , nil];
        [[NSNotificationCenter defaultCenter] postNotificationName: VDownloaderProgressNotification object: self userInfo: dict];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self closeOutputStream];
    SAFE_AUTORELEASE(_connection);
    if (self.httpResponse.statusCode != 200)
    {
        if (cacheAtOtherPlace)
        {
            [[NSFileManager defaultManager] removeItemAtPath: self.cachePath error: nil];
        }
        else
        {
            [[NSFileManager defaultManager] removeItemAtPath: self.filePath error: nil];
        }
        NSLog(@"Downloading error");
        downloadingStatus = VDownloaderStatusFailedWithServerError;
        [self postFinishNotificationWithStatus: downloadingStatus];
        return;
    }
    if (cacheAtOtherPlace && ![self.cachePath isEqualToString: self.filePath])
    {
       // NSLog(@"self.cachePath: %@", self.cachePath);
       // NSLog(@"self.filePath: %@", self.filePath);
        [[NSFileManager defaultManager] removeItemAtPath: self.filePath error: nil];
        BOOL ret = [[NSFileManager defaultManager] moveItemAtPath: self.cachePath toPath: self.filePath error: nil];
        if (!ret) 
        {
            NSLog(@"move failed");
            downloadingStatus = VDownloaderStatusFailedWithOutputError;
            [self postFinishNotificationWithStatus: downloadingStatus];
            return;
        }
    }
    NSLog(@"ok");
    downloadingStatus = VDownloaderStatusDownloaded;
    [self postFinishNotificationWithStatus: downloadingStatus];
}

- (void)closeOutputStream
{
    if (outputStream) 
    {
        [outputStream close];
        SAFE_RELEASE(outputStream);
    }
}

- (void)clearCache
{
    if ([[NSFileManager defaultManager] fileExistsAtPath: self.cachePath]) 
    {
        [[NSFileManager defaultManager] removeItemAtPath: self.cachePath error: nil];
    }
}

- (void)postFinishNotificationWithStatus: (VDownloaderStatus)status
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInteger: status], VDownloaderStatusKey
                          , self.url, VDownloaderUrlKey
                          , nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: VDownloaderFinishedNotification object: self userInfo: dict];
    
    [self autorelease];
}

- (void)retry
{
    NSLog(@"[VDownlader]: start retry...");
    [self reset];
    [self startSendRequest];
}

+ (NSString*)defaultCachePathForUrl: (NSString*)aUrl
{
    NSString* path = [VUtil cachePath];
    NSData* data = [aUrl dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion: YES];
   return [path stringByAppendingPathComponent: [data sha1Hash]];
}
@end
