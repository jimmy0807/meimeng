//
//  CDMemberQinyou+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/4/25.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberQinyou.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberQinyou (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *birthday;
@property (nullable, nonatomic, retain) NSNumber *card_id;
@property (nullable, nonatomic, retain) NSString *card_no;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSString *image_name;
@property (nullable, nonatomic, retain) NSString *last_update;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *partner_id;
@property (nullable, nonatomic, retain) NSString *partner_name;
@property (nullable, nonatomic, retain) NSNumber *qy_id;
@property (nullable, nonatomic, retain) NSString *relative_card_no;
@property (nullable, nonatomic, retain) NSString *remark;
@property (nullable, nonatomic, retain) NSString *telephone;
@property (nullable, nonatomic, retain) CDMember *member;

@end

NS_ASSUME_NONNULL_END
