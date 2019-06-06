//
//  CDStaffRole.h
//  Boss
//
//  Created by lining on 15/8/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDStaff;

@interface CDStaffRole : NSManagedObject

@property (nonatomic, retain) NSNumber * roleID;
@property (nonatomic, retain) NSString * roleName;
@property (nonatomic, retain) NSSet *staffs;
@end

@interface CDStaffRole (CoreDataGeneratedAccessors)

- (void)addStaffsObject:(CDStaff *)value;
- (void)removeStaffsObject:(CDStaff *)value;
- (void)addStaffs:(NSSet *)values;
- (void)removeStaffs:(NSSet *)values;

@end
