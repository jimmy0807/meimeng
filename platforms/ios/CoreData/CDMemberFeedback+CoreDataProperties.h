//
//  CDMemberFeedback+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/8/12.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberFeedback.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberFeedback (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *employee_id;
@property (nullable, nonatomic, retain) NSString *employee_name;
@property (nullable, nonatomic, retain) NSNumber *feedback_id;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSNumber *operate_id;
@property (nullable, nonatomic, retain) NSString *operate_name;
@property (nullable, nonatomic, retain) NSNumber *shop_id;
@property (nullable, nonatomic, retain) NSString *shop_name;
@property (nullable, nonatomic, retain) NSString *last_update;
@property (nullable, nonatomic, retain) NSString *display_name;
@property (nullable, nonatomic, retain) CDMember *member;

@end

NS_ASSUME_NONNULL_END
