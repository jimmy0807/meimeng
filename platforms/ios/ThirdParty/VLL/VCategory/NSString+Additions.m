//
//  NSString+Additions.m
//  Spark
//
//  Created by Vincent on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Additions.h"
#import "NSData+Additions.h"

@implementation NSString (Additions)

- (NSString*) sha1Hash
{
    return [[self dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion: YES] sha1Hash];
}

+ (NSString*) generateGUID
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    
    // transfer ownership of the string
    // to the autorelease pool
    [uuidString autorelease];
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}

- (BOOL)isUrl
{
    return [self hasPrefix: @"http://"] || [self hasPrefix: @"https://"];
}

- (NSString *)urlEncode
{
    NSString *encode = [NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), kCFStringEncodingUTF8)) autorelease];
    if (encode)
    {
        return encode;
    }
    
    return @"";
}

- (NSString *)urlDecode
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


@end
