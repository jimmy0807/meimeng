//
//  CDPosConsumeProduct+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/5/6.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDPosConsumeProduct.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDPosConsumeProduct (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *card_id;
@property (nullable, nonatomic, retain) NSString *card_name;
@property (nullable, nonatomic, retain) NSNumber *consume_product_line_id;
@property (nullable, nonatomic, retain) NSNumber *consume_qty;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSString *remark;
@property (nullable, nonatomic, retain) NSNumber *pack_product_line_id;
@property (nullable, nonatomic, retain) NSString *pack_product_line_name;

@end

NS_ASSUME_NONNULL_END
