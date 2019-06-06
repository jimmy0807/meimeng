//
//  CDMemberCard.h
//  Boss
//
//  Created by XiaXianBing on 2016-4-19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDMember, CDMemberCardAmount, CDMemberCardArrears, CDMemberCardConsume, CDMemberCardPoint, CDMemberCardProject, CDMemberPriceList, CDPosOperate, CDStore;

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberCard : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "CDMemberCard+CoreDataProperties.h"
