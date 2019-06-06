//
//  CDPermissionModel.h
//  Boss
//
//  Created by jimmy on 15/5/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDPermission;

@interface CDPermissionModel : NSManagedObject

@property (nonatomic, retain) NSNumber * modelID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * last_time;
@property (nonatomic, retain) NSSet *permission;
@end

@interface CDPermissionModel (CoreDataGeneratedAccessors)

- (void)addPermissionObject:(CDPermission *)value;
- (void)removePermissionObject:(CDPermission *)value;
- (void)addPermission:(NSSet *)values;
- (void)removePermission:(NSSet *)values;

@end
