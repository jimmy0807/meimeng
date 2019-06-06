//
//  BSProjectAttributeRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSProjectAttributeRequest.h"
#import "BSProjectAttributeLineRequest.h"

@implementation BSProjectAttributeRequest

- (BOOL)willStart
{
    self.tableName = @"product.attribute";
    self.filter = @[];
    self.field = @[@"id", @"name", @"value_ids", @"create_date", @"write_date"];
    
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
        NSArray *attributes = [coreDataManager fetchAllProjectAttribute];
        NSMutableArray *oldAttributes = [NSMutableArray arrayWithArray:attributes];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *attributeID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDProjectAttribute *attribute = [coreDataManager findEntity:@"CDProjectAttribute" withValue:attributeID forKey:@"attributeID"];
            if (attribute)
            {
                [oldAttributes removeObject:attribute];
            }
            else
            {
                attribute = [coreDataManager insertEntity:@"CDProjectAttribute"];
                attribute.attributeID = attributeID;
            }
            
            attribute.attributeName = [dict stringValueForKey:@"name"];
            attribute.createDate = [dict stringValueForKey:@"create_date"];
            attribute.lastUpdate = [dict stringValueForKey:@"write_date"];
            NSArray *values = [dict arrayValueForKey:@"value_ids"];
            for (int i = 0; i < values.count; i++)
            {
                NSNumber *valueID = [values objectAtIndex:i];
                CDProjectAttributeValue *value = [coreDataManager findEntity:@"CDProjectAttributeValue" withValue:valueID forKey:@"attributeValueID"];
                value.attributeID = attribute.attributeID;
                value.attributeName = attribute.attributeName;
                value.attribute = attribute;
            }
        }
        
        [coreDataManager deleteObjects:oldAttributes];
        [coreDataManager save:nil];
        
        BSProjectAttributeLineRequest *request = [[BSProjectAttributeLineRequest alloc] init];
        [request execute];
        return;
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectAttributeResponse object:self userInfo:params];
}

@end
