//
//  BSProjectAttributePriceRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/5/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSProjectAttributePriceRequest.h"
#import "BSCoreDataManager.h"
#import "BSProjectAttributeValueRequest.h"

@implementation BSProjectAttributePriceRequest

- (BOOL)willStart
{
    self.tableName = @"product.attribute.price";
    self.filter = @[];
    self.field = @[@"id", @"display_name", @"product_tmpl_id", @"value_id", @"price_extra", @"create_date", @"write_date"];
    
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
        NSArray *attributePriceArray = [coreDataManager fetchAllProjectAttributePrice];
        [coreDataManager deleteObjects:attributePriceArray];
        [coreDataManager save:nil];
        
        for (NSDictionary *dict in resultList)
        {
            CDProjectAttributePrice *attributePrice = [coreDataManager findEntity:@"CDProjectAttributePrice" withValue:[[dict objectForKey:@"value_id"] objectAtIndex:0] forKey:[NSString stringWithFormat:@"templateID == %@ && attributeValueID", [[dict objectForKey:@"product_tmpl_id"] objectAtIndex:0]]];
            if (attributePrice)
            {
                continue;
            }
            
            NSNumber *attributePriceID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            attributePrice = [coreDataManager findEntity:@"CDProjectAttributePrice" withValue:attributePriceID forKey:@"attributePriceID"];
            attributePrice = [coreDataManager insertEntity:@"CDProjectAttributePrice"];
            attributePrice.attributePriceID = attributePriceID;
            
            attributePrice.attributePriceName = [dict stringValueForKey:@"display_name"];
            attributePrice.createDate = [dict stringValueForKey:@"create_date"];
            attributePrice.lastUpdate = [dict stringValueForKey:@"write_date"];
            if ([[dict objectForKey:@"product_tmpl_id"] isKindOfClass:[NSArray class]])
            {
                attributePrice.templateID = [NSNumber numberWithInteger:[[[dict objectForKey:@"product_tmpl_id"] objectAtIndex:0] integerValue]];
                attributePrice.templateName = [[dict objectForKey:@"product_tmpl_id"] objectAtIndex:1];
            }
            
            if ([[dict objectForKey:@"value_id"] isKindOfClass:[NSArray class]])
            {
                attributePrice.attributeValueID = [NSNumber numberWithInteger:[[[dict objectForKey:@"value_id"] objectAtIndex:0] integerValue]];
                attributePrice.attributeValueName = [[dict objectForKey:@"value_id"] objectAtIndex:1];
            }
            attributePrice.extraPrice = [NSNumber numberWithDouble:[[dict objectForKey:@"price_extra"] doubleValue]];
        }
        [coreDataManager save:nil];
        
        BSProjectAttributeValueRequest *request = [[BSProjectAttributeValueRequest alloc] init];
        [request execute];
        return;
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectAttributePriceResponse object:self userInfo:params];
}

@end
