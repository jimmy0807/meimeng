//
//  HomeCountData.h
//  Boss
//
//  Created by jimmy on 15/7/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCountData : NSObject<NSCoding>

@property(nonatomic, strong)NSString* incomeDate;
@property(nonatomic, strong)NSString* totalIncome;

@property(nonatomic, strong)NSString* passengerFlowDate;
@property(nonatomic, strong)NSString* totalpassengerFlow;

@property(nonatomic, strong)NSString* myTodayInComeDate;
@property(nonatomic, strong)NSString* totalMyTodayInCome;

@property(nonatomic, strong)NSString* myAppointmentDate;
@property(nonatomic, strong)NSString* totalMyAppointment;

+(HomeCountData*)currentData;
-(void)save;
+(void)deleteHomeCountData;

-(NSString*)getTodayIncome;
-(NSString*)getMyTodayIncome;
-(NSString*)getPassengerFlow;
-(NSString*)getMyAppointmentCount;

- (NSString*)getToday;

@end
