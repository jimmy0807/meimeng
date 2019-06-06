//
//  BSFetchFollowPeroidRequest.m
//  Boss
//
//  Created by lining on 16/5/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchFollowPeroidRequest.h"

@implementation BSFetchFollowPeroidRequest


- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.account.period";
    self.filter = @[@[@"special",@"=",@0]];
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldPeroids = [NSMutableArray arrayWithArray:[dataManager fetchMemberFollowPeriodsWithMonth:0]];
        for (NSDictionary *params in retArray) {
            NSNumber *peroid_id = [params numberValueForKey:@"id"];
            CDMemberFollowPeroid *period = [dataManager findEntity:@"CDMemberFollowPeroid" withValue:peroid_id forKey:@"period_id"];
            if (period) {
                [oldPeroids removeObject:period];
            }
            else
            {
                period = [dataManager insertEntity:@"CDMemberFollowPeroid"];
                period.period_id = peroid_id;
            }
            period.name = [params stringValueForKey:@"name"];
            period.special = [params numberValueForKey:@"special"];
        }
        
        [dataManager deleteObjects:oldPeroids];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败,请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchFollowPeroidResponse object:nil userInfo:dict];
}




@end
