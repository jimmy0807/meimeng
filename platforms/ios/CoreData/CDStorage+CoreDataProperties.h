//
//  CDStorage+CoreDataProperties.h
//  Boss
//
//  Created by jiangfei on 16/7/25.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDStorage.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDStorage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *completeName;
@property (nullable, nonatomic, retain) NSString *displayName;
@property (nullable, nonatomic, retain) NSNumber *location_id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *storage_id;
@property (nullable, nonatomic, retain) NSNumber *shop_id;
@property (nullable, nonatomic, retain) NSString *shop_name;
@property (nullable, nonatomic, retain) NSSet<CDPanDian *> *panDian;
@property (nullable, nonatomic, retain) NSSet<CDPurchaseOrder *> *purchaseOrder;

@end

@interface CDStorage (CoreDataGeneratedAccessors)

- (void)addPanDianObject:(CDPanDian *)value;
- (void)removePanDianObject:(CDPanDian *)value;
- (void)addPanDian:(NSSet<CDPanDian *> *)values;
- (void)removePanDian:(NSSet<CDPanDian *> *)values;

- (void)addPurchaseOrderObject:(CDPurchaseOrder *)value;
- (void)removePurchaseOrderObject:(CDPurchaseOrder *)value;
- (void)addPurchaseOrder:(NSSet<CDPurchaseOrder *> *)values;
- (void)removePurchaseOrder:(NSSet<CDPurchaseOrder *> *)values;

@end

NS_ASSUME_NONNULL_END
