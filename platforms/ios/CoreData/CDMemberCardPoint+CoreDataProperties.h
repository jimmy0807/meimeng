//
//  CDMemberCardPoint+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/5/19.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberCardPoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberCardPoint (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *card_id;
@property (nullable, nonatomic, retain) NSString *card_name;
@property (nullable, nonatomic, retain) NSString *create_date;
@property (nullable, nonatomic, retain) NSNumber *exchange_point;
@property (nullable, nonatomic, retain) NSNumber *point;
@property (nullable, nonatomic, retain) NSNumber *point_id;
@property (nullable, nonatomic, retain) NSNumber *shop_id;
@property (nullable, nonatomic, retain) NSString *shop_name;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) CDMemberCard *card;
@property (nullable, nonatomic, retain) CDMember *member;

@end

NS_ASSUME_NONNULL_END
