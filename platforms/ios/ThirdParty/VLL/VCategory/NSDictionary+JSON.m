//
//  NSDictionary+JSON.m
//  YUNIO
//
//  Created by Vincent Xiao on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+JSON.h"
#import "SBJson.h"

@implementation NSDictionary (JSON)

+ (id)dictionaryWithJSONData: (NSData*)data
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
    if (![obj isKindOfClass: [NSDictionary class]]) 
    {
        if ([obj isKindOfClass:[NSArray class]]) {
            return [obj objectAtIndex:0];
        }
        return nil;
    } 
    return obj;
}

@end
