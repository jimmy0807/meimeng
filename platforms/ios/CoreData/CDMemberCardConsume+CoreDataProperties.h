//
//  CDMemberCardConsume+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/4/27.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberCardConsume.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberCardConsume (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *card_id;
@property (nullable, nonatomic, retain) NSString *card_name;
@property (nullable, nonatomic, retain) NSNumber *consume_id;
@property (nullable, nonatomic, retain) NSNumber *consume_qty;
@property (nullable, nonatomic, retain) NSString *create_date;
@property (nullable, nonatomic, retain) NSNumber *member_id;
@property (nullable, nonatomic, retain) NSString *member_name;
@property (nullable, nonatomic, retain) NSNumber *operate_id;
@property (nullable, nonatomic, retain) NSString *opreate_name;
@property (nullable, nonatomic, retain) NSNumber *pack_price;
@property (nullable, nonatomic, retain) NSNumber *pack_product_line_id;
@property (nullable, nonatomic, retain) NSString *pack_product_line_name;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSNumber *price_unit;
@property (nullable, nonatomic, retain) NSNumber *product_id;
@property (nullable, nonatomic, retain) NSString *product_name;
@property (nullable, nonatomic, retain) NSNumber *qty;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) CDMemberCard *card;
@property (nullable, nonatomic, retain) CDMember *member;

@end

NS_ASSUME_NONNULL_END
