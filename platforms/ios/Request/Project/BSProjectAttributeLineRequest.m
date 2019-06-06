//
//  BSProjectAttributeLineRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/6/17.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSProjectAttributeLineRequest.h"
#import "BSCoreDataManager.h"

@interface BSProjectAttributeLineRequest ()

@end

@implementation BSProjectAttributeLineRequest

- (BOOL)willStart
{
    self.tableName = @"product.attribute.line";
    self.filter = @[];
    self.field = @[@"id", @"display_name", @"product_tmpl_id", @"attribute_id", @"value_ids", @"create_date", @"write_date"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSLog(@"%@",resultList);
    NSMutableDictionary *params;
    if (resultStr.length != 0 && resultList != nil)
    {
        BSCoreDataManager *coreDataManager = [BSCoreDataManager currentManager];
        NSArray *attributeLineArray = [coreDataManager fetchAllProjectAttributeLine];
        NSMutableArray *oldAttributeLineArray = [NSMutableArray arrayWithArray:attributeLineArray];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *attributeLineID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDProjectAttributeLine *attributeLine = [coreDataManager findEntity:@"CDProjectAttributeLine" withValue:attributeLineID forKey:@"attributeLineID"];
            if (attributeLine)
            {
                [oldAttributeLineArray removeObject:attributeLine];
            }
            else
            {
                attributeLine = [coreDataManager insertEntity:@"CDProjectAttributeLine"];
                attributeLine.attributeLineID = attributeLineID;
            }
            
            attributeLine.attributeLineName = [dict stringValueForKey:@"display_name"];
            attributeLine.templateID = [NSNumber numberWithInteger:[[[dict objectForKey:@"product_tmpl_id"] objectAtIndex:0] integerValue]];
            attributeLine.templateName = [[dict objectForKey:@"product_tmpl_id"] objectAtIndex:1];
            NSNumber *attributeID = [NSNumber numberWithInteger:[[[dict objectForKey:@"attribute_id"] objectAtIndex:0] integerValue]];
            attributeLine.attributeID = attributeID;
            attributeLine.attributeName = [[dict objectForKey:@"attribute_id"] objectAtIndex:1];
            attributeLine.attribute = [coreDataManager findEntity:@"CDProjectAttribute" withValue:attributeID forKey:@"attributeID"];
            attributeLine.createDate = [dict stringValueForKey:@"create_date"];
            attributeLine.lastUpdate = [dict stringValueForKey:@"write_date"];
            
            attributeLine.attributeValues = [[NSOrderedSet alloc] init];
            attributeLine.isSelected = @0;
            NSArray *values = [dict objectForKey:@"value_ids"];
            if ([values isKindOfClass:[NSArray class]] && values.count > 0)
            {
                for (int i = 0; i < values.count; i++)
                {
                    NSNumber *valueId = [NSNumber numberWithInteger:[[values objectAtIndex:i] integerValue]];
                    CDProjectAttributeValue *attributeValue = [coreDataManager findEntity:@"CDProjectAttributeValue" withValue:valueId forKey:@"attributeValueID"];
                    if (attributeValue)
                    {
                        [attributeValue addAttributeLinesObject:attributeLine];
                    }
                }
            }
        }
        [coreDataManager deleteObjects:oldAttributeLineArray];
        [coreDataManager save:nil];
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectAttributeLineResponse object:self userInfo:params];
}

@end
