//
//  BSFetchPosMonthIncomeRequest.m
//  Boss
//
//  Created by jimmy on 15/10/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchPosMonthIncomeRequest.h"
#import "BSDataManager.h"

@implementation BSFetchPosMonthIncomeRequest

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.account.overview";
    
    NSString *start = nil;
    NSString *end = nil;
    
    [BSDataManager getTwoYearString:&start end:&end];
    
    self.needCompany = YES;
    self.filter = @[@[@"create_date",@">=",start],@[@"create_date",@"<=",end]];
    self.field = @[@"total_in_amount",@"period_id",@"shop_id"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    
    if ([retArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        [dataManager deleteObjects:[dataManager fetchHistoryPosMonthIncome]];
        
        [retArray enumerateObjectsUsingBlock:^(NSDictionary* params, NSUInteger index, BOOL *stop)
        {
            CDPosMonthIncome* p = [dataManager insertEntity:@"CDPosMonthIncome"];
            p.sortIndex = @(index);
            p.money = [params numberValueForKey:@"total_in_amount"];
            NSString* time = [params arrayNameValueForKey:@"period_id"];
            NSArray* separate = [time componentsSeparatedByString:@"/"];
            p.month = @([separate[0] integerValue]);
            p.year = @([separate[1] integerValue]);
            p.storeID = [params arrayIDValueForKey:@"shop_id"];
            p.storeName = [params arrayNameValueForKey:@"shop_id"];
        }];
        
        [dataManager save:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kFetchPosMonthIncomeResponse object:nil userInfo:nil];
    }
}

@end
