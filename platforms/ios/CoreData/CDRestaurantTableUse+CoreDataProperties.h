//
//  CDRestaurantTableUse+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/6/29.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDRestaurantTableUse.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDRestaurantTableUse (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *use_id;
@property (nullable, nonatomic, retain) NSString *lastUpdate;
@property (nullable, nonatomic, retain) NSNumber *table_id;
@property (nullable, nonatomic, retain) NSString *table_name;
@property (nullable, nonatomic, retain) NSString *start_date;
@property (nullable, nonatomic, retain) NSString *end_date;
@property (nullable, nonatomic, retain) NSNumber *is_book;
@property (nullable, nonatomic, retain) NSNumber *people_num;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) CDBook *book;

@end

NS_ASSUME_NONNULL_END
