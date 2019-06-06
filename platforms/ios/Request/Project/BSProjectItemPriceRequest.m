//
//  BSProjectItemPriceRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/11/16.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSProjectItemPriceRequest.h"

@interface BSProjectItemPriceRequest ()
@property (nonatomic, strong) NSArray *projectIds;
@property (nonatomic, strong) NSNumber *priceListId;
@end


@implementation BSProjectItemPriceRequest

- (id)initWithProjectIds:(NSArray *)projectIds priceListId:(NSNumber *)pricelistId
{
    self = [super init];
    if (self)
    {
        self.projectIds = projectIds;
        self.priceListId = pricelistId;
    }
    
    return self;
}

- (BOOL)willStart
{
    if ( self.projectIds.count == 0 )
        return FALSE;
    
    self.tableName = @"product.product";
    self.additionalParams = @[@{@"tz":@"Asia/Shanghai"}, @{@"pricelist":self.priceListId}];
    self.filter = @[@[@"id", @"in", self.projectIds]];
    self.field = @[@"id", @"list_price", @"lst_price", @"price", @"default_code"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return YES;
}

-(void)didFinishOnMainThread
{
    NSArray *resultArray = (NSArray *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([resultArray isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *params in resultArray)
        {
            NSNumber *projectID = [params numberValueForKey:@"id"];
            CDProjectItem *project = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:projectID forKey:@"itemID"];
            if (!project)
            {
                project = [[BSCoreDataManager currentManager] insertEntity:@"CDProjectItem"];
                project.itemID = projectID;
            }
            project.defaultCode = [params stringValueForKey:@"default_code"];
            
            [dict setObject:[params objectForKey:@"price"] forKey:projectID];
        }
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求支付方式发生错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectItemPriceResponse object:nil userInfo:dict];
}

@end
