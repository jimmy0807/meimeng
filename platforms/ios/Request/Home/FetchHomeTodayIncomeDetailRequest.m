//
//  FetchHomeTodayIncomeDetailRequest.m
//  Boss
//
//  Created by jimmy on 15/7/21.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "FetchHomeTodayIncomeDetailRequest.h"
#import "HomeCountData.h"
#import "FetchHomeTodayIncomeItemRequest.h"

@implementation FetchHomeTodayIncomeDetailRequest

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.account.daily";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    PersonalProfile* profile = [PersonalProfile currentProfile];
    NSNumber* storeID = [profile.homeSelectedShopID integerValue] > 0 ? profile.homeSelectedShopID : profile.bshopId;
    self.filter = @[@[@"account_date",@"=",[dateFormat stringFromDate:[NSDate date]]],@[@"shop_id",@"=",storeID]];
    self.field = @[@"total_in_amount",@"situation_amount",@"total_out_amount",@"total_remain_amount",@"operate_ids"];
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
            
            return;
        }
        
        for ( NSDictionary *params in retArray )
        {
            [[BSCoreDataManager currentManager] deleteObjects:[[BSCoreDataManager currentManager] fetchItems:@"CDTodayIncomeMain"]];
            
            CDTodayIncomeMain * main = [[BSCoreDataManager currentManager] insertEntity:@"CDTodayIncomeMain"];
            main.today = [homeData getToday];
            main.total_in_amout = [params stringValueForKey:@"total_in_amount"];
            main.situation_amount = [params stringValueForKey:@"situation_amount"];
            main.total_out_amount = [params stringValueForKey:@"total_out_amount"];;
            main.total_remain_amount = [params stringValueForKey:@"total_remain_amount"];;
            
            NSMutableArray* itemArray = [NSMutableArray array];
            for ( NSNumber* itemID in [params arrayValueForKey:@"operate_ids"] )
            {
                CDTodayIncomeItem* items = [[BSCoreDataManager currentManager] insertEntity:@"CDTodayIncomeItem"];
                items.itemID = itemID;
                items.income = main;
                [itemArray addObject:itemID];
            }
            
            if ( itemArray.count > 0 )
            {
                FetchHomeTodayIncomeItemRequest* request = [[FetchHomeTodayIncomeItemRequest alloc] init];
                request.itemsArray = itemArray;
                [request execute];
            }
            
            [[BSCoreDataManager currentManager] save:nil];
            
            homeData.incomeDate = [homeData getToday];
            homeData.totalIncome = [NSString stringWithFormat:@"%@",[params stringValueForKey:@"total_in_amount"]];
            [homeData save];
            
            break;
        }
    }
    else
    {
        dict = [self generateResponse:@"数据请求失败，请稍后重试"];
    }
}

@end
