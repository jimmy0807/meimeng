//
//  BSProjectUomRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/6/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSProjectUomRequest.h"
#import "BSCoreDataManager.h"

@implementation BSProjectUomRequest

- (BOOL)willStart
{
    self.tableName = @"product.uom";
    self.filter = @[];
    self.field = @[@"id", @"name", @"uom_type", @"active", @"category_id"];
    
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
        NSArray *uomArray = [coreDataManager fetchAllProjectUom];
        NSMutableArray *oldUomArray = [NSMutableArray arrayWithArray:uomArray];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *uomID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDProjectUom *uom = [coreDataManager findEntity:@"CDProjectUom" withValue:uomID forKey:@"uomID"];
            if (uom)
            {
                [oldUomArray removeObject:uom];
            }
            else
            {
                uom = [coreDataManager insertEntity:@"CDProjectUom"];
                uom.uomID = uomID;
            }
            
            uom.uomName = [dict stringValueForKey:@"name"];
            uom.uomType = [dict stringValueForKey:@"uom_type"];
            uom.isActive = [NSNumber numberWithInteger:[[dict objectForKey:@"active"] integerValue]];
            if ([[dict objectForKey:@"category_id"] isKindOfClass:[NSArray class]])
            {
                uom.uomCategoryID = [NSNumber numberWithInteger:[[[dict objectForKey:@"category_id"] objectAtIndex:0] integerValue]];
                uom.uomCategoryName = [[dict objectForKey:@"category_id"] objectAtIndex:1];
            }
            else
            {
                uom.uomCategoryID = [NSNumber numberWithInteger:0];
                uom.uomCategoryName = @"";
            }
        }
        [coreDataManager deleteObjects:oldUomArray];
        [coreDataManager save:nil];
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectUomResponse object:self userInfo:params];
}

@end
