//
//  BSFetchProductPriceListRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/11/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchProductPriceListRequest.h"

@implementation BSFetchProductPriceListRequest

- (BOOL)willStart
{
    self.tableName = @"product.pricelist";
    self.field = @[@"name", @"id", @"born_uuid", @"start_money", @"refill_money", @"points_change_money"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([resultList isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSArray *priceList = [dataManager fetchAllPriceList];
        NSMutableArray *oldPriceList = [NSMutableArray arrayWithArray:priceList];
        
        for(NSDictionary *params in resultList)
        {
            NSNumber *priceId = [params numberValueForKey:@"id"];
            CDMemberPriceList *priceList = [dataManager findEntity:@"CDMemberPriceList" withValue:priceId forKey:@"priceID"];
            if( !priceList )
            {
                priceList = [dataManager insertEntity:@"CDMemberPriceList"];
                priceList.priceID = priceId;
            }
            else
            {
                [oldPriceList removeObject:priceList];
            }
            
            priceList.canUse = @(YES);
            if ([[params stringValueForKey:@"born_uuid"] length] == 0 || [[params stringValueForKey:@"born_uuid"] isEqualToString:@"0"])
            {
                //priceList.canUse = @(NO);
            }
            
            if (priceList.name.length == 0)
            {
                priceList.name = [params stringValueForKey:@"name"];
            }
            
            priceList.start_money = [NSNumber numberWithFloat:[[params stringValueForKey:@"start_money"] floatValue]];
            priceList.refill_money = [NSNumber numberWithFloat:[[params stringValueForKey:@"refill_money"] floatValue]];
            priceList.points2Money = [NSNumber numberWithFloat:[[params stringValueForKey:@"points_change_money"] floatValue]];
        }
        
        [dataManager deleteObjects:oldPriceList];
        [dataManager save:nil];
        [dict setObject:@0 forKey:@"rc"];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchProductPriceListResponse object:nil userInfo:dict];
}

@end
