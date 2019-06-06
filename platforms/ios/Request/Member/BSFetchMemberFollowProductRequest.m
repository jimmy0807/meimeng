//
//  BSFetchMemberFollowProductRequest.m
//  Boss
//
//  Created by lining on 16/5/9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchMemberFollowProductRequest.h"

@implementation BSFetchMemberFollowProductRequest

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.customer.follow.product";
    if (self.follow) {
        self.filter = @[@[@"follow_id",@"=",self.follow.follow_id]];
    }
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldFollowProducts = [NSMutableArray arrayWithArray:[dataManager fetchMemberFollowProductsWithFollow:self.follow]];
        for (NSDictionary *params in retArray) {
            NSNumber *line_id = [params numberValueForKey:@"id"];
            CDMemberFollowProduct *followProduct = [dataManager findEntity:@"CDMemberFollowProduct" withValue:line_id forKey:@"line_id"];
            if (followProduct) {
                [oldFollowProducts removeObject:followProduct];
            }
            else
            {
                followProduct = [dataManager insertEntity:@"CDMemberFollowProduct"];
                followProduct.line_id = line_id;
            }
            followProduct.is_main_product = [params numberValueForKey:@"is_main_product"];
            followProduct.product_id = [params arrayIDValueForKey:@"product_id"];
            followProduct.product_name =  [params arrayNameValueForKey:@"product_id"];
            
            followProduct.follow_id = [params arrayIDValueForKey:@"follow_id"];
            followProduct.follow_name = [params arrayNameValueForKey:@"follow_id"];
            
            followProduct.qty = [params numberValueForKey:@"qty"];
            followProduct.is_main_product = [params numberValueForKey:@"is_main_product"];
        }
        [dataManager deleteObjects:oldFollowProducts];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberFollowProductResponse object:nil userInfo:dict];
}

@end
