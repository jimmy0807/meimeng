//
//  CDPosMonthIncome+CoreDataProperties.h
//  Boss
//
//  Created by lining on 15/11/30.
//  Copyright © 2015年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDPosMonthIncome.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDPosMonthIncome (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *money;
@property (nullable, nonatomic, retain) NSNumber *month;
@property (nullable, nonatomic, retain) NSNumber *sortIndex;
@property (nullable, nonatomic, retain) NSNumber *storeID;
@property (nullable, nonatomic, retain) NSString *storeName;
@property (nullable, nonatomic, retain) NSString *time;
@property (nullable, nonatomic, retain) NSNumber *year;

@end

NS_ASSUME_NONNULL_END
