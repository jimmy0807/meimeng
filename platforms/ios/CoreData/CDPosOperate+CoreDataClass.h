//
//  CDPosOperate+CoreDataClass.h
//  ds
//
//  Created by jimmy on 16/11/7.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDBook, CDCouponCard, CDCurrentUseItem, CDKeShi, CDMember, CDMemberCard, CDOperateActivity, CDPosBaseProduct, CDPosCommission, CDPosCoupon, CDPosOperatePayInfo, CDRestaurantTable, CDStore, CDYimeiImage;

NS_ASSUME_NONNULL_BEGIN

@interface CDPosOperate : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "CDPosOperate+CoreDataProperties.h"
