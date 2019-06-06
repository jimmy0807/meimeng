//
//  CDMyTodayInComeItem.h
//  Boss
//
//  Created by jimmy on 15/7/28.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDMyTodayInComeItem : NSManagedObject

@property (nonatomic, retain) NSString * create_date;
@property (nonatomic, retain) NSNumber * itemID;
@property (nonatomic, retain) NSString * tichengfangan;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * totalMoney;
@property (nonatomic, retain) NSString * yejiMoney;
@property (nonatomic, retain) NSString * yejidian;
@property (nonatomic, retain) NSString * tichengMoney;
@property (nonatomic, retain) NSString * shopName;
@property (nonatomic, retain) NSString * shoudongMoney;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * projectName;
@property (nonatomic, retain) NSString * today;

@end
