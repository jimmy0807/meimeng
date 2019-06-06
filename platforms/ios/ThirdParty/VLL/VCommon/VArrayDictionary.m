//
//  VArrayDictionary.m
//  PaintingTycoon
//
//  Created by Vincent on 1/17/13.
//  Copyright (c) 2013 InnovClub. All rights reserved.
//

#import "VArrayDictionary.h"

@interface VArrayDictionary ()
@property(nonatomic, retain) NSMutableDictionary* arrayDictionary;
@end

@implementation VArrayDictionary

- (id)init
{
    self = [super init];
    if (self)
    {
        self.arrayDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    self.arrayDictionary = nil;
    [super dealloc];
}

- (void)addObject: (id)object forKey: (id)key
{
    if (object == nil || key == nil)
    {
        return;
    }
    NSMutableArray* array = [self.arrayDictionary objectForKey: key];
    if (array == nil)
    {
        array = [NSMutableArray array];
        [self.arrayDictionary setObject: array forKey: key];
    }
    [array addObject: object];
}

- (void)removeObject: (id)object forKey: (id<NSCopying>)key
{
    if (object == nil || key == nil)
    {
        return;
    }
    NSMutableArray* array = [self.arrayDictionary objectForKey: key];
    [array removeObject: object];
    if (array.count == 0)
    {
        [self.arrayDictionary removeObjectForKey: key];
    }
}

- (void)removeObject: (id)object
{
    if (object == nil)
    {
        return;
    }
    for (id key in self.arrayDictionary)
    {
        NSMutableArray* array = [self.arrayDictionary objectForKey: key];
        if ([array containsObject: object])
        {
            [array removeObject: object];
            if (array.count == 0)
            {
                [self.arrayDictionary removeObjectForKey: key];
            }
            break;
        }
    }
}

- (id)anyObjectForKey: (id<NSCopying>)key
{
    if (key == nil)
    {
        return nil;
    }
    NSMutableArray* array = [self.arrayDictionary objectForKey: key];
    if (array.count == 0)
    {
        return nil;
    }
    return [array objectAtIndex: 0];
}

- (id)popObjectForKey: (id<NSCopying>)key
{
    if (key == nil)
    {
        return nil;
    }
    NSMutableArray* array = [self.arrayDictionary objectForKey: key];
    if (array == nil)
    {
        return nil;
    }
    id object = [[[array lastObject] retain] autorelease];
    [array removeObject: object];
    if (array.count == 0)
    {
        [self.arrayDictionary removeObjectForKey: key];
    }
    return object;
}

- (void)removeAllObjectsForKey: (id<NSCopying>)key
{
    if(key == nil)
    {
        return;
    }
    [self.arrayDictionary removeObjectForKey: key];
}

- (void)removeAllArray
{
    [self.arrayDictionary removeAllObjects];
}
@end
