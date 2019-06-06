//
//  CDTodayIncomeItem.h
//  Boss
//
//  Created by jimmy on 15/7/28.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDTodayIncomeMain;

@interface CDTodayIncomeItem : NSManagedObject

@property (nonatomic, retain) NSString * create_date;
@property (nonatomic, retain) NSNumber * itemID;
@property (nonatomic, retain) NSString * memberName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * now_card_amount;
@property (nonatomic, retain) NSString * operateUser;
@property (nonatomic, retain) NSString * product_buy_amount;
@property (nonatomic, retain) NSString * product_conusme_amount;
@property (nonatomic, retain) NSString * shopName;
@property (nonatomic, retain) NSString * totalAmount;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) CDTodayIncomeMain *income;

@end
