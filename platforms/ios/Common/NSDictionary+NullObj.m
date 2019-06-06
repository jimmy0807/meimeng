//
//  NSDictionary+NullObj.m
//  CardBag
//
//  Created by jimmy on 13-8-23.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import "NSDictionary+NullObj.h"

@implementation NSDictionary (NullObj)

- (id)stringValueForKey:(NSString *)key
{
    id obj = [self valueForKey:key];
    
    if ( obj == nil )
    {
        return @"";
    }
    else if ( [obj isKindOfClass:[NSNull class]] )
    {
        return @"";
    }
    else if ( [obj isKindOfClass:[NSNumber class]] )
    {
        return [obj stringValue];
    }
    else if ( [obj isKindOfClass:[NSArray class]] )
    {
        return [obj componentsJoinedByString:@","];
    }
    return obj;
}

- (id)onlyStringValueForKey:(NSString *)key
{
    id obj = [self valueForKey:key];
    
    if ( obj == nil )
    {
        return @"";
    }
    else if ( [obj isKindOfClass:[NSNull class]] )
    {
        return @"";
    }
    else if ( [obj isKindOfClass:[NSNumber class]] )
    {
        return @"";
    }
    else if ( [obj isKindOfClass:[NSArray class]] )
    {
        return [(NSArray*)obj componentsJoinedByString:@","];
    }
    
    return obj;
}

-(id)numberValueForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    
    if ([obj isKindOfClass:[NSNull class]])
    {
        return [NSNumber numberWithInteger:0];
    }
    else if ( [obj isKindOfClass:[NSString class]] )
    {
        return @([obj integerValue]);
    }
    
    return obj;
}

-(NSArray*)arrayValueForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    
    if ([obj isKindOfClass:[NSArray class]])
    {
        return obj;
    }
    
    return nil;
}

-(NSString*)arrayNameValueForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    
    if ([obj isKindOfClass:[NSArray class]])
    {
        return obj[1];
    }
    
    return @"";
}

-(NSNumber *)arrayIDValueForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    
    if ([obj isKindOfClass:[NSArray class]])
    {
        return obj[0];
    }
    
    return nil;
}

-(NSNumber *)arrayNotNullIDValueForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    
    if ([obj isKindOfClass:[NSArray class]])
    {
        return obj[0];
    }
    
    return @(0);
}

@end
