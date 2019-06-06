//
//  CDMemberChangeShop+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/5/3.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberChangeShop.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberChangeShop (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *member_id;
@property (nullable, nonatomic, retain) NSString *member_name;
@property (nullable, nonatomic, retain) NSNumber *member_shop_id;
@property (nullable, nonatomic, retain) NSString *member_shop_name;
@property (nullable, nonatomic, retain) NSNumber *shop_id;
@property (nullable, nonatomic, retain) NSString *shop_name;
@property (nullable, nonatomic, retain) NSNumber *record_id;
@property (nullable, nonatomic, retain) NSNumber *card_shop_id;
@property (nullable, nonatomic, retain) NSString *card_shop_name;
@property (nullable, nonatomic, retain) NSString *create_date;
@property (nullable, nonatomic, retain) NSNumber *create_uid_id;
@property (nullable, nonatomic, retain) NSString *create_uid_name;
@property (nullable, nonatomic, retain) NSNumber *now_member_shop_id;
@property (nullable, nonatomic, retain) NSString *now_member_shop_name;
@property (nullable, nonatomic, retain) NSNumber *now_card_shop_id;
@property (nullable, nonatomic, retain) NSString *now_card_shop_name;
@property (nullable, nonatomic, retain) NSNumber *is_change_member_shop;
@property (nullable, nonatomic, retain) NSNumber *card_id;
@property (nullable, nonatomic, retain) NSString *card_name;
@property (nullable, nonatomic, retain) CDMember *member;

@end

NS_ASSUME_NONNULL_END
