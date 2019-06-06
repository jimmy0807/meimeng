//
//  FetchHomeMyTodayInComeItemRequset.m
//  Boss
//
//  Created by jimmy on 15/7/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "FetchHomeMyTodayInComeItemRequset.h"
#import "HomeCountData.h"

@implementation FetchHomeMyTodayInComeItemRequset

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"commission.worksheet.line";
    
    self.filter = @[@[@"id",@"in",self.itemsArray]];
    self.field = @[@"commission_rule_id",@"create_date",@"operate_id",@"amount_subtotal",@"commission_amt",@"operate_id",@"invoice_amt",@"point",@"adjust_amt",@"product_id",@"sale_or_do"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = nil;
    if ([retArray isKindOfClass:[NSArray class]])
    {
        PersonalProfile* profile = [PersonalProfile currentProfile];
        NSString* store = [profile getCurrentStore].storeName;
        NSString* today = [[HomeCountData currentData] getToday];
        
        [[BSCoreDataManager currentManager] deleteObjects:[[BSCoreDataManager currentManager] fetchItems:@"CDMyTodayInComeItem"]];
        for ( NSDictionary *params in retArray )
        {
            CDMyTodayInComeItem * item = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMyTodayInComeItem" withValue:[params objectForKey:@"id"] forKey:@"itemID"];
            NSString* type = [params stringValueForKey:@"sale_or_do"];;
            if ( [type isEqualToString:@"recharge"] )
            {
                item.type = @"充值业绩";
            }
            else if ( [type isEqualToString:@"do"] )
            {
                item.type = @"手工业绩";
            }
            else if ( [type isEqualToString:@"sale"] )
            {
                item.type = @"销售业绩";
            }
            
            item.tichengfangan = [params arrayNameValueForKey:@"commission_rule_id"];
            item.create_date = [params stringValueForKey:@"create_date"];
            item.name = [params arrayNameValueForKey:@"operate_id"];
            item.totalMoney = [params stringValueForKey:@"amount_subtotal"];
            item.tichengMoney = [params stringValueForKey:@"commission_amt"];
            item.shopName = store;
            item.yejiMoney = [params stringValueForKey:@"invoice_amt"];
            item.yejidian = [params stringValueForKey:@"point"];
            item.shoudongMoney = [params stringValueForKey:@"adjust_amt"];
            item.projectName = [params arrayNameValueForKey:@"product_id"];
            item.today = today;
        }
        
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"数据请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHomeMyTodayIncomeDetailResponse object:nil userInfo:nil];
}

@end
