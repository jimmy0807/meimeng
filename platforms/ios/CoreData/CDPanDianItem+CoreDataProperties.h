//
//  CDPanDianItem+CoreDataProperties.h
//  Boss
//
//  Created by lining on 15/9/17.
//  Copyright © 2015年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDPanDianItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDPanDianItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *fact_count;
@property (nullable, nonatomic, retain) NSNumber *item_id;
@property (nullable, nonatomic, retain) NSNumber *location_id;
@property (nullable, nonatomic, retain) NSString *location_name;
@property (nullable, nonatomic, retain) NSNumber *product_id;
@property (nullable, nonatomic, retain) NSString *product_name;
@property (nullable, nonatomic, retain) NSNumber *theory_count;
@property (nullable, nonatomic, retain) NSNumber *orgin_count;
@property (nullable, nonatomic, retain) CDProjectItem *projectItem;

@end

NS_ASSUME_NONNULL_END
