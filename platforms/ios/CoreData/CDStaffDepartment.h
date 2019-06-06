//
//  CDStaffDepartment.h
//  Boss
//
//  Created by lining on 15/8/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDStaff, CDStaffDepartment, CDStaffJob;

@interface CDStaffDepartment : NSManagedObject

@property (nonatomic, retain) NSString * completeName;
@property (nonatomic, retain) NSNumber * department_id;
@property (nonatomic, retain) NSString * department_name;
@property (nonatomic, retain) NSString * job_ids;
@property (nonatomic, retain) NSString * manage_name;
@property (nonatomic, retain) NSNumber * manager_id;
@property (nonatomic, retain) NSNumber * parnter_id;
@property (nonatomic, retain) NSSet *childDepartments;
@property (nonatomic, retain) NSSet *job;
@property (nonatomic, retain) CDStaffDepartment *parentDepartment;
@property (nonatomic, retain) NSSet *staffs;
@property (nonatomic, retain) CDStaff *manager;
@end

@interface CDStaffDepartment (CoreDataGeneratedAccessors)

- (void)addChildDepartmentsObject:(CDStaffDepartment *)value;
- (void)removeChildDepartmentsObject:(CDStaffDepartment *)value;
- (void)addChildDepartments:(NSSet *)values;
- (void)removeChildDepartments:(NSSet *)values;

- (void)addJobObject:(CDStaffJob *)value;
- (void)removeJobObject:(CDStaffJob *)value;
- (void)addJob:(NSSet *)values;
- (void)removeJob:(NSSet *)values;

- (void)addStaffsObject:(CDStaff *)value;
- (void)removeStaffsObject:(CDStaff *)value;
- (void)addStaffs:(NSSet *)values;
- (void)removeStaffs:(NSSet *)values;

@end
