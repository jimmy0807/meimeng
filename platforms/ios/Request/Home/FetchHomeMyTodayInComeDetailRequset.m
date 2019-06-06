//
//  FetchHomeMyTodayInComeDetailRequset.m
//  Boss
//
//  Created by jimmy on 15/7/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "FetchHomeMyTodayInComeDetailRequset.h"
#import "HomeCountData.h"
#import "HomeCountDataManager.h"
#import "FetchHomeMyTodayInComeItemRequset.h"

@implementation FetchHomeMyTodayInComeDetailRequset

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"commission.worksheet";
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    NSNumber* storeID = [profile.homeSelectedShopID integerValue] > 0 ? profile.homeSelectedShopID : profile.bshopId;
    self.filter = @[@[@"shop_id",@"=",storeID],@[@"period_id",@"=",[HomeCountDataManager sharedManager].period],@[@"salesperson_id",@"in",[HomeCountDataManager sharedManager].userIDs]];
    self.field = @[@"amount_total",@"worksheet_lines"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    if ([retArray isKindOfClass:[NSArray class]])
    {
        HomeCountData* homeData = [HomeCountData currentData];
        homeData.myTodayInComeDate = [homeData getToday];
        CGFloat totalMoney = 0;
        
        NSMutableArray* worksheetLinesArray = [NSMutableArray array];
        for ( NSDictionary* params in retArray )
        {
            totalMoney = totalMoney + [params[@"amount_total"] floatValue];
            NSArray* worksheetLines = [params arrayValueForKey:@"worksheet_lines"];
            for( NSNumber* lineID in worksheetLines )
            {
                [worksheetLinesArray addObject:lineID];
            }
        }
        
        homeData.totalMyTodayInCome = [NSString stringWithFormat:@"%.01f",totalMoney];
        [homeData save];
        
        if ( worksheetLinesArray.count > 0 )
        {
            FetchHomeMyTodayInComeItemRequset* request = [[FetchHomeMyTodayInComeItemRequset alloc] init];
            request.itemsArray = worksheetLinesArray;
            [request execute];
        }
        else
        {
            [[BSCoreDataManager currentManager] deleteObjects:[[BSCoreDataManager currentManager] fetchItems:@"CDMyTodayInComeItem"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHomeMyTodayIncomeDetailResponse object:nil userInfo:nil];
        }
    }
}

@end
