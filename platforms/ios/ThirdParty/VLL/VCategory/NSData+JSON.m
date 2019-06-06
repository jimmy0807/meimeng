//
//  NSData+JSON.m
//  YUNIO
//
//  Created by Vincent on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSData+JSON.h"
#import "SBJsonWriter.h"

@implementation NSData (JSON)
+ (NSData*)jsonDataWithObject: (id) object
{
    NSData* data = nil;
//    Class jsonSerializationClass = NSClassFromString(@"NSJSONSerialization");
    // iOS > 5.0
    if (0)
    {
        data = [NSJSONSerialization dataWithJSONObject: object options: NSJSONWritingPrettyPrinted error: nil];
    }
    else 
    {
        SBJsonWriter* writer = [[SBJsonWriter alloc] init];
        NSString* str = [writer stringWithObject: object];
        data = [str dataUsingEncoding: NSUTF8StringEncoding];
        [writer release];
    }
    return data;
}
@end
