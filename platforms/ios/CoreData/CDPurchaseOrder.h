//
//  CDPurchaseOrder.h
//  Boss
//
//  Created by lining on 15/7/28.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDAssessor, CDProvider, CDPurchaseOrderLine, CDStorage, CDStore, CDWarehouse;

@interface CDPurchaseOrder : NSManagedObject

@property (nonatomic, retain) NSNumber * amount_tax;
@property (nonatomic, retain) NSNumber * amount_total;
@property (nonatomic, retain) NSNumber * amount_untax;
@property (nonatomic, retain) NSString * approve_date;
@property (nonatomic, retain) NSString * date_order;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * order_line;
@property (nonatomic, retain) NSNumber * orderId;
@property (nonatomic, retain) NSString * orderNo;
@property (nonatomic, retain) NSString * pricelist;
@property (nonatomic, retain) NSNumber * shipped;
@property (nonatomic, retain) NSString * shipped_rate;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * validator_name;
@property (nonatomic, retain) CDAssessor *assessor;
@property (nonatomic, retain) NSOrderedSet *orderlines;
@property (nonatomic, retain) CDProvider *provider;
@property (nonatomic, retain) CDWarehouse *warehouse;
@property (nonatomic, retain) CDStore *shop;
@property (nonatomic, retain) CDStorage *storage;
@end

@interface CDPurchaseOrder (CoreDataGeneratedAccessors)

- (void)insertObject:(CDPurchaseOrderLine *)value inOrderlinesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromOrderlinesAtIndex:(NSUInteger)idx;
- (void)insertOrderlines:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeOrderlinesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInOrderlinesAtIndex:(NSUInteger)idx withObject:(CDPurchaseOrderLine *)value;
- (void)replaceOrderlinesAtIndexes:(NSIndexSet *)indexes withOrderlines:(NSArray *)values;
- (void)addOrderlinesObject:(CDPurchaseOrderLine *)value;
- (void)removeOrderlinesObject:(CDPurchaseOrderLine *)value;
- (void)addOrderlines:(NSOrderedSet *)values;
- (void)removeOrderlines:(NSOrderedSet *)values;
@end
