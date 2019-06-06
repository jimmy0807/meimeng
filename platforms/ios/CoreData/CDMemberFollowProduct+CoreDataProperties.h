//
//  CDMemberFollowProduct+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/5/13.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberFollowProduct.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberFollowProduct (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *line_id;
@property (nullable, nonatomic, retain) NSNumber *product_id;
@property (nullable, nonatomic, retain) NSString *product_name;
@property (nullable, nonatomic, retain) NSNumber *qty;
@property (nullable, nonatomic, retain) NSNumber *follow_id;
@property (nullable, nonatomic, retain) NSString *follow_name;
@property (nullable, nonatomic, retain) NSNumber *is_main_product;
@property (nullable, nonatomic, retain) CDMemberFollow *follow;

@end

NS_ASSUME_NONNULL_END
