//
//  CDStaff+CoreDataClass.h
//  ds
//
//  Created by lining on 16/10/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDCommissionRule, CDMember, CDPosConfig, CDStaffDepartment, CDStaffJob, CDStaffRole, CDStore, CDUser;

NS_ASSUME_NONNULL_BEGIN

@interface CDStaff : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "CDStaff+CoreDataProperties.h"
