//
//  CDMemberCardAmount+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/4/27.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberCardAmount.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberCardAmount (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSNumber *amount_id;
@property (nullable, nonatomic, retain) NSNumber *card_amount;
@property (nullable, nonatomic, retain) NSNumber *card_id;
@property (nullable, nonatomic, retain) NSString *card_name;
@property (nullable, nonatomic, retain) NSString *create_date;
@property (nullable, nonatomic, retain) NSNumber *gift_amount;
@property (nullable, nonatomic, retain) NSNumber *journal_id;
@property (nullable, nonatomic, retain) NSString *journal_name;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSNumber *operate_id;
@property (nullable, nonatomic, retain) NSString *operate_name;
@property (nullable, nonatomic, retain) NSNumber *point;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) CDMemberCard *card;
@property (nullable, nonatomic, retain) CDMember *member;

@end

NS_ASSUME_NONNULL_END
