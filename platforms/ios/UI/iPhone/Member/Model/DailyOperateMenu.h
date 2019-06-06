//
//  DailyOperateMenu.h
//  Boss
//
//  Created by mac on 15/8/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyOperateMenu : NSObject
/*
 
 CDPassengerFlow* p = [[BSCoreDataManager currentManager] insertEntity:@"CDPassengerFlow"];
 p.create_date = [params stringValueForKey:@"create_date"];
 p.itemID = [params numberValueForKey:@"id"];
 p.memberName = [params arrayNameValueForKey:@"member_id"];
 p.name = [params stringValueForKey:@"name"];;
 p.operateUser = [params arrayNameValueForKey:@"create_uid"];
 p.shopName = [params arrayNameValueForKey:@"shop_id"];
 p.cardNo = [params arrayNameValueForKey:@"card_id"];
 p.totalAmount = [params stringValueForKey:@"now_amount"];
 p.type = [params stringValueForKey:@"type"];
 */
@property(nonatomic,strong)NSString *create_date;
@property(nonatomic,strong)NSNumber *itemID;
@property(nonatomic,strong)NSString *memberName;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *operateUser;
@property(nonatomic,strong)NSString *shopName;
@property(nonatomic,strong)NSString *cardNo;
@property(nonatomic,strong)NSString *totalAmount;
@property(nonatomic,strong)NSString *type;
@end
