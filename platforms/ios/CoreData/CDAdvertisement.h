//
//  CDAdvertisement.h
//  Boss
//
//  Created by jimmy on 15/7/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDAdvertisementItem;

@interface CDAdvertisement : NSManagedObject

@property (nonatomic, retain) NSNumber * interval;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * adID;
@property (nonatomic, retain) NSOrderedSet *items;
@end

@interface CDAdvertisement (CoreDataGeneratedAccessors)

- (void)insertObject:(CDAdvertisementItem *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(CDAdvertisementItem *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)values;
- (void)addItemsObject:(CDAdvertisementItem *)value;
- (void)removeItemsObject:(CDAdvertisementItem *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;
@end
