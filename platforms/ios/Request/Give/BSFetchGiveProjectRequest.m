//
//  BSFetchGiveProjectRequest.m
//  Boss
//
//  Created by lining on 16/9/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchGiveProjectRequest.h"

@implementation BSFetchGiveProjectRequest
- (BOOL)willStart
{
    self.tableName = @"product.product";
    self.filter = @[@[@"born_category",@"=",@(kPadBornCategoryProject)]];
    self.field = @[@"id",@"name",@"born_category",@"lst_price",@"type",@"active",@"sale_ok"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([resultList isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *coreDataManager = [BSCoreDataManager currentManager];
        for (NSDictionary *params in resultList) {
            NSNumber *itemID = [NSNumber numberWithInteger:[[params objectForKey:@"id"] integerValue]];
            CDProjectItem *item = [coreDataManager findEntity:@"CDProjectItem" withValue:itemID forKey:@"itemID"];
            if (item)
            {
//                [oldItems removeObject:item];
            }
            else
            {
                item = [coreDataManager insertEntity:@"CDProjectItem"];
                item.itemID = itemID;
            }
            
            item.itemName = [params stringValueForKey:@"name"];
            
            item.bornCategory = [NSNumber numberWithInteger:[[params objectForKey:@"born_category"] integerValue]];
            item.totalPrice = [NSNumber numberWithDouble:[[params objectForKey:@"lst_price"] doubleValue]];
            item.isActive = [NSNumber numberWithBool:[[params objectForKey:@"active"] boolValue]];
            item.canSale = [NSNumber numberWithBool:[[params objectForKey:@"sale_ok"] boolValue]];
            item.type = [params stringValueForKey:@"type"];
            
        }
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchGiveProjectResponse object:nil userInfo:dict];
}
@end
