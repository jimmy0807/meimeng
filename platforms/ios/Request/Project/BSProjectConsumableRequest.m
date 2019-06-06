//
//  BSProjectConsumableRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/5/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSProjectConsumableRequest.h"
#import "BSCoreDataManager.h"

@implementation BSProjectConsumableRequest


- (BOOL)willStart
{
    self.tableName = @"born.consumables.line";
    self.filter = @[];
    self.field = @[@"id", @"base_product_id", @"product_id", @"qty", @"uom_id", @"is_stock", @"create_date", @"write_date"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if (resultStr.length != 0 && resultList != nil)
    {
        BSCoreDataManager *coreDataManager = [BSCoreDataManager currentManager];
        NSArray *consumableArray = [coreDataManager fetchAllProjectConsumable];
        NSMutableArray *oldConsumableArray = [NSMutableArray arrayWithArray:consumableArray];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *consumableID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDProjectConsumable *consumable = [coreDataManager findEntity:@"CDProjectConsumable" withValue:consumableID forKey:@"consumableID"];
            if (consumable)
            {
                [oldConsumableArray removeObject:consumable];
            }
            else
            {
                consumable = [coreDataManager insertEntity:@"CDProjectConsumable"];
                consumable.consumableID = consumableID;
            }
            
            consumable.createDate = [dict stringValueForKey:@"create_date"];
            consumable.lastUpdate = [dict stringValueForKey:@"write_date"];
            consumable.baseProductID = [NSNumber numberWithInteger:[[[dict objectForKey:@"base_product_id"] objectAtIndex:0] integerValue]];
            consumable.baseProductName = [[dict objectForKey:@"base_product_id"] objectAtIndex:1];
            consumable.productID = [NSNumber numberWithInteger:[[[dict objectForKey:@"product_id"] objectAtIndex:0] integerValue]];
            consumable.productName = [[dict objectForKey:@"product_id"] objectAtIndex:1];
            consumable.isStock = [NSNumber numberWithBool:[[dict objectForKey:@"is_stock"] boolValue]];
            consumable.uomID = [NSNumber numberWithInteger:[[[dict objectForKey:@"uom_id"] objectAtIndex:0] integerValue]];
            consumable.uomName = [[dict objectForKey:@"uom_id"] objectAtIndex:1];
            consumable.amount = [NSNumber numberWithInteger:[[dict objectForKey:@"amount"] floatValue]];
            consumable.qty = [NSNumber numberWithInteger:[[dict objectForKey:@"qty"] integerValue]];
        }
        [coreDataManager deleteObjects:oldConsumableArray];
        [coreDataManager save:nil];
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectConsumableResponse object:self userInfo:params];
}

@end
