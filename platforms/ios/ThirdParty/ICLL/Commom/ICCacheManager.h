//
//  ICCacheManager.h
//  BetSize
//
//  Created by jimmy on 12-9-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDownloader.h"
#import "VUIImageItem.h"

@interface ICCacheManager : NSObject

+ (BOOL)hasCache: (NSString*)fileName;
+ (NSString*)cacheFolderPath;
+ (NSString*)cacheFilePathFromName: (NSString*)fileName;
+ (BOOL)createCacheDictionary;
+ (BOOL)saveCache: (NSString*)fileName fileData:(NSData*)fileData;

@end
