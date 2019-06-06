//
//  BSFetchStoreListRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/3/31.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchStoreListRequest.h"
#import "BSCoreDataManager.h"
#import "ChineseToPinyin.h"

@interface BSFetchStoreListRequest ()
@property (nonatomic, strong) NSString *username;
@end

@implementation BSFetchStoreListRequest


- (BOOL)willStart
{
    self.tableName = @"born.shop";
    NSMutableArray *filters = [NSMutableArray array];
    
    if (self.shopid)
    {
        [filters addObject:@[@"id", @"in", self.shopid]];
        if (self.username)
        {
            [filters addObject:@[@"name", @"ilike", self.username]];
        }
    }
    self.filter = filters;

    self.field = @[@"name",@"id",@"born_uuid",];
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
        NSArray *stores = [coreDataManager fetchStoreListWithShopID:self.shopid];
        NSMutableArray *oldStores = [NSMutableArray arrayWithArray:stores];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *storeID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDStore *store = [coreDataManager findEntity:@"CDStore" withValue:storeID forKey:@"storeID"];
            if (store)
            {
                [oldStores removeObject:store];
            }
            else
            {
                store = [coreDataManager insertEntity:@"CDStore"];
                store.storeID = storeID;
            }
            
            store.storeName = [dict stringValueForKey:@"name"];
            store.storeNameLetter = [ChineseToPinyin pinyinFromChiniseString:store.storeName];
            store.createDate = [dict stringValueForKey:@"create_date"];
            store.lastUpdate = [dict stringValueForKey:@"write_date"];
            store.logo = [dict stringValueForKey:@"logo"];
            store.phone = [dict stringValueForKey:@"phone"];
            store.email = [dict stringValueForKey:@"email"];
            store.mobile = [dict stringValueForKey:@"mobile"];
            store.shop_uuid = [dict stringValueForKey:@"born_uuid"];
            if (![[dict objectForKey:@"company_id"] isKindOfClass:[NSArray class]])
            {
                store.companyID = [NSNumber numberWithInteger:[[[dict objectForKey:@"parent_id"] objectAtIndex:0] integerValue]];
                store.companyName = [[dict objectForKey:@"parent_id"] objectAtIndex:1];
            }
        }
        [coreDataManager deleteObjects:oldStores];
        [coreDataManager save:nil];
    }
    else
    {
        params = [self generateResponse:@"请求发生错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchStoreListResponse object:self userInfo:params];
}

@end
