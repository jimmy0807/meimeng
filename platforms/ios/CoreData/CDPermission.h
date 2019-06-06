//
//  CDPermission.h
//  Boss
//
//  Created by jimmy on 15/5/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDPermissionModel;

@interface CDPermission : NSManagedObject

@property (nonatomic, retain) NSNumber * access;
@property (nonatomic, retain) NSNumber * identity;
@property (nonatomic, retain) NSString * last_time;
@property (nonatomic, retain) NSNumber * permissionID;
@property (nonatomic, retain) CDPermissionModel *model;

@end
