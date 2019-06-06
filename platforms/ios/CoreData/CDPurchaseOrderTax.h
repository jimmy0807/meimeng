//
//  CDPurchaseOrderTax.h
//  Boss
//
//  Created by lining on 15/7/22.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDPurchaseOrderLine;

@interface CDPurchaseOrderTax : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * tax_id;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * parent_id;
@property (nonatomic, retain) NSSet *orderline;
@end

@interface CDPurchaseOrderTax (CoreDataGeneratedAccessors)

- (void)addOrderlineObject:(CDPurchaseOrderLine *)value;
- (void)removeOrderlineObject:(CDPurchaseOrderLine *)value;
- (void)addOrderline:(NSSet *)values;
- (void)removeOrderline:(NSSet *)values;

@end
