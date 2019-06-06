//
//  FetchHomeTodayIncomeItemRequest.m
//  Boss
//
//  Created by jimmy on 15/7/22.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "FetchHomeTodayIncomeItemRequest.h"

@implementation FetchHomeTodayIncomeItemRequest

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.card.operate";
    
    self.filter = @[@[@"id",@"in",self.itemsArray]];
    //product_buy_amount 产品销售
    //now_card_amount 储值变动
    self.field = @[@"type",@"name",@"now_amount",@"consume_buy_amount",@"member_id",@"product_buy_amount",@"now_card_amount",@"create_date",@"shop_id",@"create_uid"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = nil;
    if ([retArray isKindOfClass:[NSArray class]])
    {
        NSArray* array = [[BSCoreDataManager currentManager] fetchItems:@"CDMyTodayInComeItem"];
        [[BSCoreDataManager currentManager] deleteObjects:array];
        for ( NSDictionary *params in retArray )
        {
            CDTodayIncomeItem* item = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDTodayIncomeItem" withValue:[params objectForKey:@"id"] forKey:@"itemID"];
            item.type = [params stringValueForKey:@"type"];
            item.name = [params stringValueForKey:@"name"];
            item.totalAmount = [params stringValueForKey:@"now_amount"];
            item.product_conusme_amount = [params stringValueForKey:@"consume_buy_amount"];
            item.product_buy_amount = [params stringValueForKey:@"product_buy_amount"];
            item.now_card_amount = [params stringValueForKey:@"now_card_amount"];
            item.create_date = [params stringValueForKey:@"create_date"];
            item.memberName = [params arrayNameValueForKey:@"member_id"];
            item.shopName = [params arrayNameValueForKey:@"shop_id"];
            item.operateUser = [params arrayNameValueForKey:@"create_uid"];
        }
        
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"数据请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHomeTodayIncomeDetailResponse object:nil userInfo:nil];
}

@end
