//
//  FetchProviderRequest.m
//  Boss
//
//  Created by lining on 15/5/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchProviderRequest.h"
#import "BSCoreDataManager+Customized.h"

@implementation BSFetchProviderRequest
-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"res.partner";
    self.filter = @[@[@"supplier",@"=",@"true"]];
    
//    self.field = @[@"name",@"property_product_pricelist"];
    self.field = @[];
    
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSArray *providers = [dataManager fetchAllProviders];
        NSMutableArray *oldProviders = [NSMutableArray arrayWithArray:providers];
        for (NSDictionary *params in retArray) {
            
            NSNumber *provider_id = [params numberValueForKey:@"id"];
            CDProvider *provider = [dataManager findEntity:@"CDProvider" withValue:provider_id forKey:@"provider_id"];
            if (provider) {
                [oldProviders removeObject:provider];
            }
            else
            {
                provider = [dataManager insertEntity:@"CDProvider"];
                provider.provider_id = provider_id;
            }
            
            provider.name = [params stringValueForKey:@"display_name"];
            NSLog(@"name: %@",provider.name);
            provider.website = [params stringValueForKey:@"website"];
            provider.email = [params stringValueForKey:@"email"];
            provider.address = [params stringValueForKey:@"street"];
            provider.job = [params stringValueForKey:@"function"];
            provider.telephone = [params stringValueForKey:@"mobile"];
            provider.phone = [params stringValueForKey:@"phone"];
            provider.title = [params stringValueForKey:@"title"];
            provider.fax = [params stringValueForKey:@"fax"];
            provider.write_date = [params stringValueForKey:@"write_date"];
            
            NSArray *priceList = [params arrayValueForKey:@"property_product_pricelist_purchase"];
            if (priceList.count > 0) {
                provider.product_pricelist_id = priceList[0];
            }
            
            //logo名字 自己写的
            provider.logoName = [NSString stringWithFormat:@"provider_%d.png",provider_id];
           
        }
        [dataManager deleteObjects:oldProviders];
        [dataManager save:nil];
    }
    else
    {
        [dict setObject:@(-1) forKey:@"rc"];
        [dict setObject:@"请求数据失败，请稍后重试" forKey:@"rm"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchProviderRequest object:nil userInfo:dict];
    
}

@end
