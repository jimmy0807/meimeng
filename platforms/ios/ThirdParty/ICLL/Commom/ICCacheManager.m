//
//  ICCacheManager.m
//  BetSize
//
//  Created by jimmy on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICCacheManager.h"
#import "NSString+Additions.h"
#import "VUtil.h"
@implementation ICCacheManager

+ (BOOL)hasCache: (NSString*)fileName
{
    return [[NSFileManager defaultManager] fileExistsAtPath: [ICCacheManager cacheFilePathFromName: fileName]];
}

+ (NSString*)cacheFolderPath
{
    NSArray* array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachePath = [array objectAtIndex: 0];
    return  cachePath;
}

+ (NSString*)cacheFilePathFromName: (NSString*)fileName
{
    return [[ICCacheManager cacheFolderPath] stringByAppendingPathComponent: [fileName sha1Hash]];
}

+ (BOOL)createCacheDictionary
{
    NSString* folderPath = [[ICCacheManager cacheFolderPath] stringByAppendingPathComponent: @"vdownloader"];
    return [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (BOOL)saveCache: (NSString*)fileName fileData:(NSData*)fileData
{
    NSString* filePath = [[VUtil cachePath] stringByAppendingPathComponent: [fileName sha1Hash]];
    return [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileData attributes:nil];
}

@end
