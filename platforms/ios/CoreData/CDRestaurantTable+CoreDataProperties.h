//
//  CDRestaurantTable+CoreDataProperties.h
//  Boss
//
//  Created by jimmy on 16/6/22.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDRestaurantTable.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDRestaurantTable (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isActive;
@property (nullable, nonatomic, retain) NSString *lastUpdate;
@property (nullable, nonatomic, retain) NSString *tableColor;
@property (nullable, nonatomic, retain) NSNumber *tableHeight;
@property (nullable, nonatomic, retain) NSNumber *tableHorizontal;
@property (nullable, nonatomic, retain) NSNumber *tableID;
@property (nullable, nonatomic, retain) NSString *tableName;
@property (nullable, nonatomic, retain) NSNumber *tableSeats;
@property (nullable, nonatomic, retain) NSNumber *tableSequence;
@property (nullable, nonatomic, retain) NSString *tableShape;
@property (nullable, nonatomic, retain) NSNumber *tableState;
@property (nullable, nonatomic, retain) NSNumber *tableVertical;
@property (nullable, nonatomic, retain) NSNumber *tableWidth;
@property (nullable, nonatomic, retain) NSNumber *usingQty;
@property (nullable, nonatomic, retain) CDRestaurantFloor *floor;
@property (nullable, nonatomic, retain) NSSet<CDPosOperate *> *operate;

@end

@interface CDRestaurantTable (CoreDataGeneratedAccessors)

- (void)addOperateObject:(CDPosOperate *)value;
- (void)removeOperateObject:(CDPosOperate *)value;
- (void)addOperate:(NSSet<CDPosOperate *> *)values;
- (void)removeOperate:(NSSet<CDPosOperate *> *)values;

@end

NS_ASSUME_NONNULL_END
