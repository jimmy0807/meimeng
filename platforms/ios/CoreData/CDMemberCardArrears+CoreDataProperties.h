//
//  CDMemberCardArrears+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/4/27.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberCardArrears.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberCardArrears (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *arrearsAmount;
@property (nullable, nonatomic, retain) NSNumber *arrearsID;
@property (nullable, nonatomic, retain) NSString *arrearsName;
@property (nullable, nonatomic, retain) NSString *arrearsType;
@property (nullable, nonatomic, retain) NSString *createDate;
@property (nullable, nonatomic, retain) NSString *lastUpdate;
@property (nullable, nonatomic, retain) NSNumber *memberCardID;
@property (nullable, nonatomic, retain) NSString *memberCardNumber;
@property (nullable, nonatomic, retain) NSNumber *memberID;
@property (nullable, nonatomic, retain) NSString *memberName;
@property (nullable, nonatomic, retain) NSNumber *operateID;
@property (nullable, nonatomic, retain) NSString *operateName;
@property (nullable, nonatomic, retain) NSString *plantPaymentDate;
@property (nullable, nonatomic, retain) NSNumber *remainAmount;
@property (nullable, nonatomic, retain) NSNumber *repaymentAmount;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) NSNumber *tempAmount;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSNumber *unRepaymentAmount;
@property (nullable, nonatomic, retain) CDMember *member;
@property (nullable, nonatomic, retain) CDMemberCard *memberCard;

@end

NS_ASSUME_NONNULL_END
