//
//  CDStore.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-16.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDMember, CDMemberCard, CDPosOperate, CDPurchaseOrder, CDStaff;

NS_ASSUME_NONNULL_BEGIN

@interface CDStore : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "CDStore+CoreDataProperties.h"
