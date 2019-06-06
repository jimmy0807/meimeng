//
//  CDMemberCallRecord+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/5/5.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberCallRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberCallRecord (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *record_id;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSNumber *is_answer;
@property (nullable, nonatomic, retain) NSNumber *shop_id;
@property (nullable, nonatomic, retain) NSString *shop_name;
@property (nullable, nonatomic, retain) NSNumber *member_id;
@property (nullable, nonatomic, retain) NSString *member_name;
@property (nullable, nonatomic, retain) NSString *last_update;

@end

NS_ASSUME_NONNULL_END
