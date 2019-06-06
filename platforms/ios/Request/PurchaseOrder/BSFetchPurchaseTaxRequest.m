//
//  BSFetchPurchaseTaxRequest.m
//  Boss
//
//  Created by lining on 15/7/15.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchPurchaseTaxRequest.h"

@implementation BSFetchPurchaseTaxRequest

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"account.tax";
    self.filter = @[@[@"type_tax_use",@"!=",@"sale"]];
    
//    self.filter = @[];
//    self.filter = @[];
    self.field = @[];
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSArray *taxes = [dataManager fetchPurchaseOrderTaxs];
        NSMutableArray *oldTaxes = [NSMutableArray arrayWithArray:taxes];
        for (NSDictionary *params in retArray) {
            NSNumber *tax_id = [params numberValueForKey:@"id"];
            CDPurchaseOrderTax *tax = [dataManager findEntity:@"CDPurchaseOrderTax" withValue:tax_id forKey:@"tax_id"];
            if (tax) {
                [oldTaxes removeObject:tax];
            }
            else
            {
                tax = [dataManager insertEntity:@"CDPurchaseOrderTax"];
                tax.tax_id = tax_id;
            }
            tax.name = [params stringValueForKey:@"name"];
            tax.parent_id = [params numberValueForKey:@"parent_id"];
            tax.amount = [params numberValueForKey:@"amount"];
            
        }
        [dataManager deleteObjects:oldTaxes];
        [dataManager save:nil];
        [dict setObject:@0 forKey:@"rc"];
    }
    else
    {
        [dict setObject:@-1 forKey:@"rc"];
        [dict setObject:@"请求失败,请稍后重试" forKey:@"rm"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPurchaseTaxResponse object:nil userInfo:dict];
}
@end
