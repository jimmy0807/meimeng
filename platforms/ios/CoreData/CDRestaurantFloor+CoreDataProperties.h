//
//  CDRestaurantFloor+CoreDataProperties.h
//  Boss
//
//  Created by jimmy on 16/6/22.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDRestaurantFloor.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDRestaurantFloor (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *floorID;
@property (nullable, nonatomic, retain) NSString *floorName;
@property (nullable, nonatomic, retain) NSNumber *floorSequence;
@property (nullable, nonatomic, retain) NSString *lastUpdate;
@property (nullable, nonatomic, retain) NSNumber *isActive;
@property (nullable, nonatomic, retain) CDPosConfig *posConfig;
@property (nullable, nonatomic, retain) NSSet<CDRestaurantTable *> *tables;

@end

@interface CDRestaurantFloor (CoreDataGeneratedAccessors)

- (void)addTablesObject:(CDRestaurantTable *)value;
- (void)removeTablesObject:(CDRestaurantTable *)value;
- (void)addTables:(NSSet<CDRestaurantTable *> *)values;
- (void)removeTables:(NSSet<CDRestaurantTable *> *)values;

@end

NS_ASSUME_NONNULL_END
