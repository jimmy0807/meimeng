//
//  BSFetchPosProductCategoryRequest.m
//  Boss
//
//  Created by lining on 16/9/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchPosProductCategoryRequest.h"

@implementation BSFetchPosProductCategoryRequest
- (BOOL)willStart
{
    self.tableName = @"product.product";
    //self.filter = @[@"|", @[@"active", @"=", [NSNumber numberWithBool:NO]], @[@"active", @"=", [NSNumber numberWithBool:YES]]];
    
    if (self.fetchProductIDs.count > 0) {
        self.filter = @[@[@"id", @"in", self.fetchProductIDs]];
    }
    self.field = @[@"id", @"name", @"born_category"];
    
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
   
        for (NSDictionary *dict in resultList)
        {
            NSNumber *itemID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDProjectItem *item = [coreDataManager uniqueEntityForName:@"CDProjectItem" withValue:itemID forKey:@"itemID"];
           
            
            item.itemName = [dict stringValueForKey:@"name"];

            item.bornCategory = [NSNumber numberWithInteger:[[dict objectForKey:@"born_category"] integerValue]];
        }
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPosProductCategoryResponse object:self userInfo:params];
}

@end
