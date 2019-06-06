//
//  CDStaffJob+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/5/19.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDStaffJob.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDStaffJob (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *currentCount;
@property (nullable, nonatomic, retain) NSNumber *inspectCount;
@property (nullable, nonatomic, retain) NSNumber *job_id;
@property (nullable, nonatomic, retain) NSString *job_name;
@property (nullable, nonatomic, retain) CDStaffDepartment *department;
@property (nullable, nonatomic, retain) NSSet<CDStaff *> *staffs;

@end

@interface CDStaffJob (CoreDataGeneratedAccessors)

- (void)addStaffsObject:(CDStaff *)value;
- (void)removeStaffsObject:(CDStaff *)value;
- (void)addStaffs:(NSSet<CDStaff *> *)values;
- (void)removeStaffs:(NSSet<CDStaff *> *)values;

@end

NS_ASSUME_NONNULL_END
