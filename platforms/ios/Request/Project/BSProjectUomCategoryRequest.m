//
//  BSProjectUomCategoryRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/6/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSProjectUomCategoryRequest.h"
#import "BSCoreDataManager.h"
#import "BSProjectUomRequest.h"

@implementation BSProjectUomCategoryRequest

- (BOOL)willStart
{
    self.tableName = @"product.uom.categ";
    self.filter = @[];
    self.field = @[@"id", @"name"];
    
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
        NSArray *uomCategorys = [coreDataManager fetchAllProjectUomCategory];
        NSMutableArray *oldUomCategorys = [NSMutableArray arrayWithArray:uomCategorys];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *uomCategoryID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDProjectUomCategory *uomCategory = [coreDataManager findEntity:@"CDProjectUomCategory" withValue:uomCategoryID forKey:@"uomCategoryID"];
            if (uomCategory)
            {
                [oldUomCategorys removeObject:uomCategory];
            }
            else
            {
                uomCategory = [coreDataManager insertEntity:@"CDProjectUomCategory"];
                uomCategory.uomCategoryID = uomCategoryID;
            }
            
            uomCategory.uomCategoryName = [dict stringValueForKey:@"name"];
        }
        [coreDataManager deleteObjects:oldUomCategorys];
        [coreDataManager save:nil];
        
        BSProjectUomRequest *request = [[BSProjectUomRequest alloc] init];
        [request execute];
        return;
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectUomCategoryResponse object:self userInfo:params];
}


@end
