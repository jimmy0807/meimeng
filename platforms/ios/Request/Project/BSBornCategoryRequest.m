//
//  BSBornCategoryRequest.m
//  Boss
//
//  Created by XiaXianBing on 16/1/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSBornCategoryRequest.h"
#import "BSCoreDataManager.h"

@implementation BSBornCategoryRequest

- (BOOL)willStart
{
    self.tableName = @"born.product.category";
    self.filter = @[];
    self.field = @[@"id", @"name", @"type", @"code", @"active", @"sequence", @"__last_update",@"total_product_qty"];
    
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
        NSArray *categoryArray = [coreDataManager fetchAllBornCategory];
        NSMutableArray *oldCategoryArray = [NSMutableArray arrayWithArray:categoryArray];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *bornCategoryID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDBornCategory *bornCategory = [coreDataManager findEntity:@"CDBornCategory" withValue:bornCategoryID forKey:@"bornCategoryID"];
            if (bornCategory)
            {
                [oldCategoryArray removeObject:bornCategory];
            }
            else
            {
                bornCategory = [coreDataManager insertEntity:@"CDBornCategory"];
                bornCategory.bornCategoryID = bornCategoryID;
            }
            
            bornCategory.bornCategoryName = [dict objectForKey:@"name"];
            bornCategory.code = [NSNumber numberWithInteger:[[dict stringValueForKey:@"code"] integerValue]];
            bornCategory.sequence = [NSNumber numberWithInteger:[[dict stringValueForKey:@"sequence"] integerValue]];
            bornCategory.isActive = [NSNumber numberWithBool:[[dict objectForKey:@"active"] boolValue]];
            bornCategory.type = [dict stringValueForKey:@"type"];//单品 组合套餐 套盒
            bornCategory.note = [dict stringValueForKey:@"note"];
            bornCategory.lastUpdate = [dict stringValueForKey:@"__last_update"];
            bornCategory.total_product_qty = [dict numberValueForKey:@"total_product_qty"];
        }
        [coreDataManager deleteObjects:oldCategoryArray];
        [coreDataManager save:nil];
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSBornCategoryResponse object:self userInfo:params];
}

@end
