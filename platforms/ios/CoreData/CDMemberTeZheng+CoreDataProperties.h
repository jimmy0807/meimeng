//
//  CDMemberTeZheng+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/4/26.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberTeZheng.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberTeZheng (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *member_id;
@property (nullable, nonatomic, retain) NSString *member_name;
@property (nullable, nonatomic, retain) NSString *tz_describle;
@property (nullable, nonatomic, retain) NSNumber *tz_id;
@property (nullable, nonatomic, retain) NSString *tz_name;
@property (nullable, nonatomic, retain) CDMember *member;
@property (nullable, nonatomic, retain) CDExtend *extend;

@end

NS_ASSUME_NONNULL_END
