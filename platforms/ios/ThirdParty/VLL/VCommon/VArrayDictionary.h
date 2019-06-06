//
//  VArrayDictionary.h
//  PaintingTycoon
//
//  Created by Vincent on 1/17/13.
//  Copyright (c) 2013 InnovClub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VArrayDictionary : NSObject

- (void)addObject: (id)object forKey: (id<NSCopying>)key;
- (void)removeObject: (id)object forKey: (id<NSCopying>)key;
- (id)anyObjectForKey: (id<NSCopying>)key;
- (id)popObjectForKey: (id<NSCopying>)key;
- (void)removeAllObjectsForKey: (id<NSCopying>)key;
- (void)removeAllArray;
// Not recommanded to use @selector(removeObject:)
- (void)removeObject: (id)object;


@end
