//
//  FetchHomeMyTodayInComeRequset.m
//  Boss
//
//  Created by jimmy on 15/7/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "FetchHomeMyTodayInComeRequset.h"
#import "HomeCountData.h"
#import "HomeCountDataManager.h"

@implementation FetchHomeMyTodayInComeRequset

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"commission.worksheet";
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    NSNumber* storeID = [profile.homeSelectedShopID integerValue] > 0 ? profile.homeSelectedShopID : profile.bshopId;
    self.filter = @[@[@"shop_id",@"=",storeID],@[@"period_id",@"=",self.period],@[@"salesperson_id",@"in",self.userIDs]];
    self.field = @[@"amount_total"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    [HomeCountDataManager sharedManager].period = self.period;
    [HomeCountDataManager sharedManager].userIDs = self.userIDs;
    
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
        for ( NSDictionary* params in retArray )
        {
            totalMoney = totalMoney + [params[@"amount_total"] floatValue];
        }
        
        homeData.totalMyTodayInCome = [NSString stringWithFormat:@"%.01f",totalMoney];
        [homeData save];
        
        if ( totalMoney == 0 )
        {
            [[BSCoreDataManager currentManager] deleteObjects:[[BSCoreDataManager currentManager] fetchItems:@"CDMyTodayInComeItem"]];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHomeCountDataResponse object:nil userInfo:nil];
    }
}

@end
