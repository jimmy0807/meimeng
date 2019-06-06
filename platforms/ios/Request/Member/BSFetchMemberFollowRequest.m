//
//  BSFetchMemberFollowRequest.m
//  Boss
//
//  Created by lining on 16/5/9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchMemberFollowRequest.h"

@implementation BSFetchMemberFollowRequest

- (BOOL)willStart
{
    [super willStart];
    
    self.tableName = @"born.customer.follow";
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldFollows = [NSMutableArray arrayWithArray:[dataManager fetchMemberFollowsWithMember:self.member]];
        for (NSDictionary *params in retArray) {
            NSNumber *follow_id = [params numberValueForKey:@"id"];
            CDMemberFollow *follow = [dataManager findEntity:@"CDMemberFollow" withValue:follow_id forKey:@"follow_id"];
            if (follow) {
                [oldFollows removeObject:follow];
            }
            else
            {
                follow = [dataManager insertEntity:@"CDMemberFollow"];
                follow.follow_id = follow_id;
            }
            follow.period_id = [params arrayIDValueForKey:@"period_id"];
            follow.period_name = [params arrayNameValueForKey:@"period_id"];
            
            NSArray *times = [follow.period_name componentsSeparatedByString:@"/"];
            follow.month = @([times[0] integerValue]);
            follow.year = @([times[1] integerValue]);
            
            follow.member_id = [params arrayIDValueForKey:@"member_id"];
            follow.member_name = [params arrayNameValueForKey:@"member_id"];
            
            follow.follow_date = [params stringValueForKey:@"follow_date"];
            
            follow.shop_id = [params arrayIDValueForKey:@"shop_id"];
            follow.shop_name = [params arrayNameValueForKey:@"shop_id"];
            
            follow.birth_date = [params stringValueForKey:@"birth_date"];
            follow.card_no = [params stringValueForKey:@"card_no"];
            follow.pricelists = [params stringValueForKey:@"pricelists"];
            follow.card_amount = [params numberValueForKey:@"card_amount"];
            follow.cource_amount = [params numberValueForKey:@"course_amount"];
            follow.other_product = [params stringValueForKey:@"other_product"];
            follow.last_month_cpxs_amount = [params numberValueForKey:@"last_month_cpxs_amount"];
            follow.last_month_come_day = [params numberValueForKey:@"last_month_come_day"];
            follow.last_month_come_count = [params numberValueForKey:@"last_month_come_count"];
            follow.first_week_come_count  = [params numberValueForKey:@"first_week_come_count"];
            follow.second_week_come_count = [params numberValueForKey:@"second_week_come_count"];
            follow.third_week_come_count = [params numberValueForKey:@"third_week_come_count"];
            follow.fourth_week_come_count = [params numberValueForKey:@"forth_week_come_count"];
            follow.yye_amount = [params numberValueForKey:@"yye_amount"];
            follow.hlxf_amount = [params numberValueForKey:@"hlxf_amount"];
            follow.cpxs_amount = [params numberValueForKey:@"cpxs_amount"];
            follow.czje_amount = [params numberValueForKey:@"czje_amount"];
            
            follow.last_yye_amount = [params numberValueForKey:@"last_yye_amount"];
            follow.last_czje_amount = [params numberValueForKey:@"last_czje_amount"];
            follow.last_hlxf_amount = [params numberValueForKey:@"last_hlxf_amount"];
            
            follow.note = [params stringValueForKey:@"note"];
        }
        [dataManager deleteObjects:oldFollows];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败,请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberFollowResponse object:nil userInfo:dict];
}

@end
