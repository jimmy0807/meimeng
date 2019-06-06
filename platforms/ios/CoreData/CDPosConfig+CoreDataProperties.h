//
//  CDPosConfig+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/5/19.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDPosConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDPosConfig (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *posID;
@property (nullable, nonatomic, retain) NSString *posName;
@property (nullable, nonatomic, retain) NSSet<CDRestaurantFloor *> *floors;
@property (nullable, nonatomic, retain) NSSet<CDStaff *> *staffs;

@end

@interface CDPosConfig (CoreDataGeneratedAccessors)

- (void)addFloorsObject:(CDRestaurantFloor *)value;
- (void)removeFloorsObject:(CDRestaurantFloor *)value;
- (void)addFloors:(NSSet<CDRestaurantFloor *> *)values;
- (void)removeFloors:(NSSet<CDRestaurantFloor *> *)values;

- (void)addStaffsObject:(CDStaff *)value;
- (void)removeStaffsObject:(CDStaff *)value;
- (void)addStaffs:(NSSet<CDStaff *> *)values;
- (void)removeStaffs:(NSSet<CDStaff *> *)values;

@end

NS_ASSUME_NONNULL_END
