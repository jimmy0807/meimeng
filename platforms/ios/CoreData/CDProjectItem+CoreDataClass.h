//
//  CDProjectItem+CoreDataClass.h
//  meim
//
//  Created by 波恩公司 on 2018/4/23.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDCouponCardProduct, CDCurrentUseItem, CDMemberCardProject, CDPanDianItem, CDPosBaseProduct, CDProjectAttributeValue, CDProjectCategory, CDProjectCheck, CDProjectConsumable, CDProjectRelated, CDProjectTemplate, CDPurchaseOrderLine, CDPurchaseOrderMoveItem;

NS_ASSUME_NONNULL_BEGIN

@interface CDProjectItem : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "CDProjectItem+CoreDataProperties.h"
