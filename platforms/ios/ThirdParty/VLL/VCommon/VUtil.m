//
//  VUtil.m
//  Spark
//
//  Created by Vincent on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VUtil.h"
#import "NSString+Additions.h"

@implementation VUtil

+ (NSString*)cachePath
{
    NSArray* array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachePath = [array objectAtIndex: 0];
    return [cachePath stringByAppendingPathComponent:@"vdownloader"];
}

+ (BOOL)hasCache:(NSString*)fileName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[VUtil cacheFilePathFromName: fileName]];
}

+ (NSString*)cacheFilePathFromName:(NSString*)fileName
{
    return [[VUtil cachePath] stringByAppendingPathComponent: [fileName sha1Hash]];
}

@end
