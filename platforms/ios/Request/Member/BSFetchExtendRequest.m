//
//  BSFetchExtendRequest.m
//  Boss
//
//  Created by lining on 16/4/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchExtendRequest.h"

@implementation BSFetchExtendRequest

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.extended";
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict;
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldExtends = [NSMutableArray arrayWithArray:[dataManager fetchExtends]];
        for (NSDictionary *params in retArray) {
            NSNumber *extend_id = [params numberValueForKey:@"id"];
            CDExtend *extend = [dataManager findEntity:@"CDExtend" withValue:extend_id forKey:@"extend_id"];
            if (extend) {
                [oldExtends removeObject:extend];
            }
            else
            {
                extend = [dataManager insertEntity:@"CDExtend"];
                extend.extend_id = extend_id;
            }
            extend.extend_name = [params stringValueForKey:@"name"];
            extend.extend_description = [params stringValueForKey:@"description"];
        }
        [dataManager deleteObjects:oldExtends];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchExtendResponse object:nil userInfo:dict];
}

@end
