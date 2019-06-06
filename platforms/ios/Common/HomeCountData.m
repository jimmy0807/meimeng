//
//  HomeCountData.m
//  Boss
//
//  Created by jimmy on 15/7/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "HomeCountData.h"

@implementation HomeCountData

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.incomeDate forKey:@"incomeDate"];
    [coder encodeObject:self.totalIncome forKey:@"totalIncome"];
    [coder encodeObject:self.passengerFlowDate forKey:@"passengerFlowDate"];
    [coder encodeObject:self.totalpassengerFlow forKey:@"totalpassengerFlow"];
    [coder encodeObject:self.myTodayInComeDate forKey:@"myTodayInComeDate"];
    [coder encodeObject:self.totalMyTodayInCome forKey:@"totalMyTodayInCome"];
    [coder encodeObject:self.myAppointmentDate forKey:@"myAppointmentDate"];
    [coder encodeObject:self.totalMyAppointment forKey:@"totalMyAppointment"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.incomeDate = [coder decodeObjectForKey:@"incomeDate"];
        self.totalIncome = [coder decodeObjectForKey:@"totalIncome"];
        self.passengerFlowDate = [coder decodeObjectForKey:@"passengerFlowDate"];
        self.totalpassengerFlow = [coder decodeObjectForKey:@"totalpassengerFlow"];
        self.myTodayInComeDate = [coder decodeObjectForKey:@"myTodayInComeDate"];
        self.totalMyTodayInCome = [coder decodeObjectForKey:@"totalMyTodayInCome"];
        self.myAppointmentDate = [coder decodeObjectForKey:@"myAppointmentDate"];
        self.totalMyAppointment = [coder decodeObjectForKey:@"totalMyAppointment"];}
    
    return self;
}

-(NSString*)getTodayIncome
{
    NSString* today = [self getToday];
    if ( [self.incomeDate isEqualToString:today] )
    {
        return self.totalIncome;
    }
    
    return @"0";
}

-(NSString*)getMyTodayIncome
{
    NSString* today = [self getToday];
    if ( [self.myTodayInComeDate isEqualToString:today] )
    {
        return self.totalMyTodayInCome;
    }
    
    return @"0";
}

-(NSString*)getPassengerFlow
{
    NSString* today = [self getToday];
    if ( [self.passengerFlowDate isEqualToString:today] )
    {
        return self.totalpassengerFlow;
    }
    
    return @"0";
}

-(NSString*)getMyAppointmentCount
{
    NSString* today = [self getToday];
    if ( [self.myAppointmentDate isEqualToString:today] )
    {
        return self.totalMyAppointment;
    }
    
    return @"0";
}

- (NSString*)getToday
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    NSString* today = [dateFormat stringFromDate:[NSDate date]];
    
    return today;
}

+(HomeCountData*)currentData
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData* profileData = [userDefault valueForKey:@"HomeCountData"];
    if ( profileData )
    {
        return (HomeCountData*)[NSKeyedUnarchiver unarchiveObjectWithData:profileData];
    }
    
    return [[HomeCountData alloc] init];
}

-(void)save
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject: [NSKeyedArchiver archivedDataWithRootObject:self] forKey: @"HomeCountData"];
    [userDefault synchronize];
}

+(void)deleteHomeCountData
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"HomeCountData"];
    [userDefault synchronize];
}

@end
