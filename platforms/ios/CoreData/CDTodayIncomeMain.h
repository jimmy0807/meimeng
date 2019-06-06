//
//  CDTodayIncomeMain.h
//  Boss
//
//  Created by jimmy on 15/7/22.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDTodayIncomeItem;

@interface CDTodayIncomeMain : NSManagedObject

@property (nonatomic, retain) NSString * situation_amount;
@property (nonatomic, retain) NSString * today;
@property (nonatomic, retain) NSString * total_in_amout;
@property (nonatomic, retain) NSString * total_out_amount;
@property (nonatomic, retain) NSString * total_remain_amount;
@property (nonatomic, retain) NSOrderedSet *items;
@end

@interface CDTodayIncomeMain (CoreDataGeneratedAccessors)

- (void)insertObject:(CDTodayIncomeItem *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(CDTodayIncomeItem *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)values;
- (void)addItemsObject:(CDTodayIncomeItem *)value;
- (void)removeItemsObject:(CDTodayIncomeItem *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;
@end
