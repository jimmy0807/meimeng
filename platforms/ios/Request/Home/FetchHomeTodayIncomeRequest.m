//
//  FetchHomeTodayIncomeRequest.m
//  Boss
//
//  Created by jimmy on 15/7/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "FetchHomeTodayIncomeRequest.h"
#import "HomeCountData.h"

@implementation FetchHomeTodayIncomeRequest

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.account.daily";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    PersonalProfile* profile = [PersonalProfile currentProfile];
    NSNumber* storeID = [profile.homeSelectedShopID integerValue] > 0 ? profile.homeSelectedShopID : profile.bshopId;
    self.filter = @[@[@"account_date",@"=",[dateFormat stringFromDate:[NSDate date]]],@[@"shop_id",@"=",storeID]];
    self.field = @[@"total_in_amount"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]])
    {
        HomeCountData* homeData = [HomeCountData currentData];
        if ( retArray.count == 0 )
        {
            homeData.incomeDate = [homeData getToday];
            homeData.totalIncome = [NSString stringWithFormat:@"%@",@"0"];
            [homeData save];
            
            [[BSCoreDataManager currentManager] deleteObjects:[[BSCoreDataManager currentManager] fetchItems:@"CDTodayIncomeMain"]];
            
            CDTodayIncomeMain * main = [[BSCoreDataManager currentManager] insertEntity:@"CDTodayIncomeMain"];
            main.today = [homeData getToday];
            main.total_in_amout = @"0";
            
            [[BSCoreDataManager currentManager] save:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHomeCountDataResponse object:nil userInfo:dict];
            return;
        }
        
        for ( NSDictionary *params in retArray )
        {
            homeData.incomeDate = [homeData getToday];
            homeData.totalIncome = [NSString stringWithFormat:@"%@",[params stringValueForKey:@"total_in_amount"]];
            [homeData save];
            
            CDTodayIncomeMain * main = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDTodayIncomeMain" withValue:[homeData getToday] forKey:@"today"];
            main.total_in_amout = [params stringValueForKey:@"total_in_amount"];
            
            [[BSCoreDataManager currentManager] save:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHomeCountDataResponse object:nil userInfo:dict];
            
            break;
        }
    }
}

@end
