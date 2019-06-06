//
//  BSProjectAttributeValueRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/5/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSProjectAttributeValueRequest.h"
#import "BSCoreDataManager.h"
#import "BSProjectAttributeRequest.h"

@implementation BSProjectAttributeValueRequest

- (BOOL)willStart
{
    self.tableName = @"product.attribute.value";
    self.filter = @[];
    self.field = @[@"id", @"name", @"display_name", @"attribute_id", @"price_ids", @"price_extra", @"create_date", @"write_date"];
    
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
        NSArray *attributeValueArray = [coreDataManager fetchAllProjectAttributeValue];
        NSMutableArray *oldAttributeValueArray = [NSMutableArray arrayWithArray:attributeValueArray];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *attributeValueID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDProjectAttributeValue *attributeValue = [coreDataManager findEntity:@"CDProjectAttributeValue" withValue:attributeValueID forKey:@"attributeValueID"];
            if (attributeValue)
            {
                [oldAttributeValueArray removeObject:attributeValue];
            }
            else
            {
                attributeValue = [coreDataManager insertEntity:@"CDProjectAttributeValue"];
                attributeValue.attributeValueID = attributeValueID;
            }
            
            attributeValue.attributeValueName = [dict stringValueForKey:@"name"];
            attributeValue.displayName = [dict stringValueForKey:@"display_name"];
            attributeValue.attributeID = [NSNumber numberWithInteger:[[[dict objectForKey:@"attribute_id"] objectAtIndex:0] integerValue]];
            attributeValue.attributeName = [[dict objectForKey:@"attribute_id"] objectAtIndex:1];
            attributeValue.createDate = [dict stringValueForKey:@"create_date"];
            attributeValue.lastUpdate = [dict stringValueForKey:@"write_date"];
            attributeValue.extraPrice = [NSNumber numberWithDouble:[[dict objectForKey:@"price_extra"] doubleValue]];
            attributeValue.isSeleted = @0;
            NSMutableSet *mutableSet = [NSMutableSet set];
            NSArray *priceIds = [dict objectForKey:@"price_ids"];
            if ([priceIds isKindOfClass:[NSArray class]] && priceIds.count > 0)
            {
                for (int i = 0; i < priceIds.count; i++)
                {
                    NSNumber *priceId = [NSNumber numberWithInteger:[[priceIds objectAtIndex:i] integerValue]];
                    CDProjectAttributePrice *attributePrice = [coreDataManager findEntity:@"CDProjectAttributePrice" withValue:priceId forKey:@"attributePriceID"];
                    if (attributePrice)
                    {
                        [mutableSet addObject:attributePrice];
                    }
                }
            }
            attributeValue.attributePrices = mutableSet;
        }
        [coreDataManager deleteObjects:oldAttributeValueArray];
        [coreDataManager save:nil];
        
        BSProjectAttributeRequest *request = [[BSProjectAttributeRequest alloc] init];
        [request execute];
        return;
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectAttributeValueResponse object:self userInfo:params];
}

@end
