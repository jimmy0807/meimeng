//
//  SAImage.m
//  ShopAssistant
//
//  Created by jimmy on 15/3/6.
//  Copyright (c) 2015年 jimmy. All rights reserved.
//

#import "SAImage.h"
#import "VFileImage.h"
#import "VDownloader.h"
#import "NSString+Additions.h"
#import "ICCacheManager.h"
#import "NSData+Additions.h"
#import "BSCoreDataManager.h"
#import "ICCommunicationManager.h"
#import "VUtil.h"

@implementation SAImageManager
IMPSharedManager(SAImageManager)
-(id)init
{
    self = [super init];
    if ( self )
    {
        self.retryTimesParams = [NSMutableDictionary dictionary];
        self.downloadingRequestParams = [NSMutableDictionary dictionary];
    }
    
    return self;
}
@end

@interface SAImage ()

@property (nonatomic, strong) NSObject *userData;
@property (nonatomic, strong) NSNumber *filterName;
@property (nonatomic, strong) NSString *fieldName;
@property (nonatomic, strong) NSString *writeDate;
@property (nonatomic, strong) SAImageComplete complete;
@property (nonatomic, assign) NSInteger retryTimes;

@property(nonatomic, strong) NSArray *array;

@end

@implementation SAImage

+(UIImage*)getImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate userData:(NSObject*)userData
{
    if ( imageName == nil )
    {
        NSLog(@"getImageWithName userData 名字为空了");
        return nil;
    }

    CDImageCache* cache = [[BSCoreDataManager currentManager] findEntity:@"CDImageCache" withValue:writeDate forKey:[NSString stringWithFormat:@"imageName == \"%@\" && create_date",imageName]];
    
    VFileImage* image = [VFileImage imageWithContentsOfFile:[VDownloader defaultCachePathForUrl:imageName]];
    if ( !image || !cache )
    {
        if ( [[SAImageManager sharedManager].retryTimesParams[imageName] integerValue] < 1 )
        {
            if ( [ICCommunicationManager currentManager].isNetworkReachability )
            {
                [SAImageManager sharedManager].retryTimesParams[imageName] = @([[SAImageManager sharedManager].retryTimesParams[imageName] integerValue] + 1);
                SAImage* request = [[SAImage alloc] initWithImageName:imageName tableName:tableName filter:filter fieldName:fieldName writeDate:writeDate userData:userData];
                [request execute];
                [SAImageManager sharedManager].downloadingRequestParams[imageName] = request;
            }
        }
    }
    
    return image;
}

+(UIImage*)getImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate completion:(SAImageComplete)completion
{
    if ( imageName == nil )
    {
        NSLog(@"getImageWithName completion 名字为空了");
        return nil;
    }
    
    NSArray *array = [imageName componentsSeparatedByString:@"%"];
    NSString *imgName = imageName;
    if (array.count > 1) {
        imgName = array[1];
    }
    CDImageCache* cache = [[BSCoreDataManager currentManager] findEntity:@"CDImageCache" withValue:writeDate forKey:[NSString stringWithFormat:@"imageName == \"%@\" && create_date",imgName]];
    
    VFileImage* image = [VFileImage imageWithContentsOfFile:[VDownloader defaultCachePathForUrl:imgName]];
    if ( !image || !cache )
    {
        if ( !cache )
        {
            [SAImageManager sharedManager].retryTimesParams[imageName] = @(0);
        }
        
        if ( [[SAImageManager sharedManager].retryTimesParams[imageName] integerValue] < 1 && ![SAImageManager sharedManager].downloadingRequestParams[imageName] )
        {
            [SAImageManager sharedManager].retryTimesParams[imageName] = @([[SAImageManager sharedManager].retryTimesParams[imageName] integerValue] + 1);
            SAImage* request = [[SAImage alloc] initWithImageName:imgName tableName:tableName filter:filter fieldName:fieldName writeDate:writeDate completion:completion];
            [request execute];
            [SAImageManager sharedManager].downloadingRequestParams[imageName] = request;
        }
        
    }
    
    return image;
}

+ (UIImage *)getImageWithName:(NSString*)imageName
{
    return [VFileImage imageWithContentsOfFile:[VDownloader defaultCachePathForUrl:imageName]];
}



- (id)initWithImageName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate userData:(NSObject*)userData
{
    self = [super init];
    if (self)
    {
        self.imageName = imageName;
        self.userData = userData;
        self.filterName = filter;
        self.fieldName = fieldName;
        self.tableName = tableName;
        self.writeDate = writeDate;
    }
    
    return self;
}

- (id)initWithImageName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate completion:(SAImageComplete)completion
{
    self = [super init];
    if (self)
    {
        self.imageName = imageName;
        self.complete = completion;
        self.filterName = filter;
        self.fieldName = fieldName;
        self.tableName = tableName;
        self.writeDate = writeDate;
    }
    
    return self;
}

- (UIImage*)getImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate userData:(NSObject*)userData
{
    return [self getImageWithName:imageName tableName:tableName filter:filter fieldName:fieldName writeDate:writeDate userData:userData completion:nil];
}


- (UIImage *)getImageWithName:(NSString *)imageName tableName:(NSString *)tableName filter:(NSNumber *)filter fieldName:(NSString *)fieldName writeDate:(NSString *)writeDate completion:(SAImageComplete)completion
{
    return [self getImageWithName:imageName tableName:tableName filter:filter fieldName:fieldName writeDate:writeDate userData:nil completion:completion];
    
}


- (UIImage *)getImageWithName:(NSString *)imageName tableName:(NSString *)tableName filter:(NSNumber *)filter fieldName:(NSString *)fieldName writeDate:(NSString *)writeDate userData:(NSObject *)userData completion:(SAImageComplete)completion
{
    if (imageName == nil) {
        NSLog(@"getImageWithName userData 名字为空了");
        return nil;
    }
    
    self.imageName = imageName;
    self.userData = userData;
    self.filterName = filter;
    self.fieldName = fieldName;
    self.tableName = tableName;
    self.writeDate = writeDate;
    self.complete  = completion;
    
    CDImageCache* cache = [[BSCoreDataManager currentManager] findEntity:@"CDImageCache" withValue:writeDate forKey:[NSString stringWithFormat:@"imageName == \"%@\" && create_date",imageName]];
    
    VFileImage *image = [VFileImage imageWithContentsOfFile:[VDownloader defaultCachePathForUrl:imageName]];
    
    if ( !cache )
    {
        if (!cache)
        {
            self.retryTimes = 0;
        }
        
        if (self.retryTimes < 1)
        {
            if ( [ICCommunicationManager currentManager].isNetworkReachability )
            {
                self.retryTimes ++;
                [self execute];
            }

        }
    }
    
    return image;
}



- (BOOL)willStart
{
    [super willStart];
    
    if ( self.filterName )
    {
        self.filter = @[self.filterName];
    }
    
    self.field =  @[self.fieldName];
    self.tableName = self.tableName;
    self.xmlStyle = @"read";
    self.requestType = BNRequestXmlImage;
    
    [self sendShopAssistantXmlStandardCommand:@"/xmlrpc/2/object" params:nil method:@"execute"];
    
    return TRUE;
}


- (void)didFinishOnMainThread
{
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    
    [[SAImageManager sharedManager].downloadingRequestParams removeObjectForKey:self.imageName];
    
    if ( [resultArray isKindOfClass:[NSArray class]] && resultArray.count > 0)
    {
        NSDictionary* params = resultArray[0];
        if ( [params[self.fieldName] isKindOfClass:[NSNumber class]] )
        {
            if (  [[params numberValueForKey:self.fieldName] integerValue] == 0 )
            {
                [VFileImage removeFileImage:[VDownloader defaultCachePathForUrl:self.imageName]];
               [[NSFileManager defaultManager] removeItemAtPath:[VDownloader defaultCachePathForUrl:self.imageName] error:nil];
                
                CDImageCache* cache = [[BSCoreDataManager currentManager] findEntity:@"CDImageCache" withValue:self.writeDate forKey:[NSString stringWithFormat:@"imageName == \"%@\" && create_date",self.imageName]];
                
                //CDImageCache* cache = [[BSCoreDataManager currentManager] findEntity:@"CDImageCache" withValue:self.imageName forKey:@"imageName"];
                if ( !cache )
                {
                    cache = [[BSCoreDataManager currentManager] insertEntity:@"CDImageCache"];
                    cache.imageName = self.imageName;
                }
                
                cache.create_date = self.writeDate;
                [[BSCoreDataManager currentManager] save:nil];
                
                if ( self.complete )
                {
                    self.complete([SAImage getImageWithName:self.imageName]);
                }
                else
                {
                    if ( self.userData )
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:VDownloaderFinishedNotification object:self userInfo:@{VDownloaderUrlKey:self.imageName,VDownloaderAdditional:self.userData}];
                    }
                    else
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:VDownloaderFinishedNotification object:self userInfo:@{VDownloaderUrlKey:self.imageName}];
                    }
                }
                return;
            }
        }
        else if ( ![params[self.fieldName] isKindOfClass:[NSString class]] )
        {
            return;
        }
        NSString* imageString = params[self.fieldName];
        NSData* imageData = [NSData dataWithBase64EncodedString:imageString];
        [ICCacheManager saveCache:self.imageName fileData:imageData];
        
        [VFileImage removeFileImage:[VDownloader defaultCachePathForUrl:self.imageName]];
        
        CDImageCache* cache = [[BSCoreDataManager currentManager] findEntity:@"CDImageCache" withValue:self.imageName forKey:@"imageName"];
        if ( !cache )
        {
            cache = [[BSCoreDataManager currentManager] insertEntity:@"CDImageCache"];
            cache.imageName = self.imageName;
        }
        
        cache.create_date = self.writeDate;
        [[BSCoreDataManager currentManager] save:nil];
        
        if ( self.complete )
        {
            self.complete([SAImage getImageWithName:self.imageName]);
        }
        else
        {
            if ( self.userData )
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:VDownloaderFinishedNotification object:self userInfo:@{VDownloaderUrlKey:self.imageName,VDownloaderAdditional:self.userData}];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:VDownloaderFinishedNotification object:self userInfo:@{VDownloaderUrlKey:self.imageName}];
            }
        }
    }
    else if ( [resultArray isKindOfClass:[NSNumber class]] )
    {
        [VFileImage removeFileImage:[VDownloader defaultCachePathForUrl:self.imageName]];
        [[NSFileManager defaultManager] removeItemAtPath:[VDownloader defaultCachePathForUrl:self.imageName] error:nil];
        
        CDImageCache* cache = [[BSCoreDataManager currentManager] findEntity:@"CDImageCache" withValue:self.imageName forKey:@"imageName"];
        if ( !cache )
        {
            cache = [[BSCoreDataManager currentManager] insertEntity:@"CDImageCache"];
            cache.imageName = self.imageName;
        }
        
        cache.create_date = self.writeDate;
        [[BSCoreDataManager currentManager] save:nil];
        
        if ( self.complete )
        {
            self.complete([SAImage getImageWithName:self.imageName]);
        }
        else
        {
            if ( self.userData )
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:VDownloaderFinishedNotification object:self userInfo:@{VDownloaderUrlKey:self.imageName,VDownloaderAdditional:self.userData}];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:VDownloaderFinishedNotification object:self userInfo:@{VDownloaderUrlKey:self.imageName}];
            }
        }
    }
}

+(void)cancelDownload:(NSString*)imageName
{
    SAImage* request = [SAImageManager sharedManager].downloadingRequestParams[imageName];
    if ( request )
    {
        [request cancel];
        [[SAImageManager sharedManager].downloadingRequestParams removeObjectForKey:imageName];

    }
}

- (void)dealloc
{
    NSLog(@"SA dealloc");
}
@end
