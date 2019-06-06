//
//  CDWarehouse.h
//  Boss
//
//  Created by lining on 15/7/28.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDPurchaseOrder;

@interface CDWarehouse : NSManagedObject

@property (nonatomic, retain) NSString * warehouse_name;
@property (nonatomic, retain) NSNumber * pick_id;
@property (nonatomic, retain) NSString * pick_name;
@property (nonatomic, retain) NSNumber * warehouse_id;
@property (nonatomic, retain) NSNumber * src_location_id;
@property (nonatomic, retain) NSString * src_location_name;
@property (nonatomic, retain) NSNumber * dest_location_id;
@property (nonatomic, retain) NSString * dest_location_name;
@property (nonatomic, retain) NSSet *purchaseOrder;
@end

@interface CDWarehouse (CoreDataGeneratedAccessors)

- (void)addPurchaseOrderObject:(CDPurchaseOrder *)value;
- (void)removePurchaseOrderObject:(CDPurchaseOrder *)value;
- (void)addPurchaseOrder:(NSSet *)values;
- (void)removePurchaseOrder:(NSSet *)values;

@end
