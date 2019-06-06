//
//  NSArray+JSON.m
//  YUNIO
//
//  Created by Vincent Xiao on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArray+JSON.h"
#import "SBJson.h"

@implementation NSArray (JSON)

+ (id)arrayWithJSONData: (NSData*)data
{
    id obj = nil;
    Class jsonSerializationClass = NSClassFromString(@"NSJSONSerialization");
    // iOS > 5.0
    if (jsonSerializationClass) 
    {
        obj = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error:nil];
    }
    else
    {
        SBJsonParser* parser = [[[SBJsonParser alloc] init] autorelease];
        obj = [parser objectWithData: data];
    }
    if (![obj isKindOfClass: [NSArray class]]) 
    {
        return nil;
    } 
    return obj;
}

- (NSData *)toJsonData
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (data.length > 0 && error == nil)
    {
        return data;
    }
    
    return nil;
}

- (NSString *)toJsonString
{
    NSData *data = [self toJsonData];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
