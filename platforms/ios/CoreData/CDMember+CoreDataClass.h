//
//  CDMember+CoreDataClass.h
//  meim
//
//  Created by 波恩公司 on 2017/11/9.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDCouponCard, CDMemberCard, CDMemberCardAmount, CDMemberCardArrears, CDMemberCardConsume, CDMemberCardPoint, CDMemberChangeShop, CDMemberFeedback, CDMemberQinyou, CDMemberTeZheng, CDMemberTitle, CDPosOperate, CDStaff, CDStore;

NS_ASSUME_NONNULL_BEGIN

@interface CDMember : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "CDMember+CoreDataProperties.h"
