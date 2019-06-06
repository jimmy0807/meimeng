//
//  CDPosOperatePayInfo+CoreDataProperties.h
//  Boss
//
//  Created by jimmy on 16/5/12.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDPosOperatePayInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDPosOperatePayInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *bank_serial_number;
@property (nullable, nonatomic, retain) NSNumber *card_amount;
@property (nullable, nonatomic, retain) NSNumber *card_id;
@property (nullable, nonatomic, retain) NSString *card_name;
@property (nullable, nonatomic, retain) NSNumber *cource_amount;
@property (nullable, nonatomic, retain) NSString *create_date;
@property (nullable, nonatomic, retain) NSNumber *gift_amount;
@property (nullable, nonatomic, retain) NSNumber *is_card;
@property (nullable, nonatomic, retain) NSNumber *journal_id;
@property (nullable, nonatomic, retain) NSString *journal_name;
@property (nullable, nonatomic, retain) NSNumber *operate_id;
@property (nullable, nonatomic, retain) NSString *operate_name;
@property (nullable, nonatomic, retain) NSNumber *pay_amount;
@property (nullable, nonatomic, retain) NSNumber *pay_id;
@property (nullable, nonatomic, retain) NSString *pay_note;
@property (nullable, nonatomic, retain) NSNumber *remain_amount;
@property (nullable, nonatomic, retain) NSNumber *shop_id;
@property (nullable, nonatomic, retain) NSString *shop_name;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) NSNumber *statement_id;
@property (nullable, nonatomic, retain) NSString *statement_name;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *pos_type;
@property (nullable, nonatomic, retain) CDPosOperate *operate;
@property (nullable, nonatomic, retain) CDPOSPayMode *payMode;

@end

NS_ASSUME_NONNULL_END
