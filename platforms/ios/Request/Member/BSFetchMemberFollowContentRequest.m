//
//  BSFetchMemberFollowContentRequest.m
//  Boss
//
//  Created by lining on 16/5/13.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchMemberFollowContentRequest.h"

@implementation BSFetchMemberFollowContentRequest
- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.customer.follow.line";
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
        NSMutableArray *oldContentProducts = [NSMutableArray arrayWithArray:[dataManager fetchMemberFollowContentsWithFollow:self.follow]];
        for (NSDictionary *params in retArray) {
            NSNumber *content_id = [params numberValueForKey:@"id"];
            CDMemberFollowContent *followContent = [dataManager findEntity:@"CDMemberFollowContent" withValue: content_id forKey:@"content_id"];
            if (followContent) {
                [oldContentProducts removeObject:followContent];
            }
            else
            {
                followContent = [dataManager insertEntity:@"CDMemberFollowContent"];
                followContent.content_id = content_id;
            }
            followContent.name = [params stringValueForKey:@"name"];
            followContent.date = [params stringValueForKey:@"create_date"];
            
            followContent.follow_id = [params arrayIDValueForKey:@"follow_id"];
            followContent.follow_name = [params arrayNameValueForKey:@"follow_id"];
            
            followContent.guwen_id = [params arrayIDValueForKey:@"employee_id"];
            followContent.guwen_name = [params arrayNameValueForKey:@"employee_id"];
            
            followContent.shop_id = [params arrayIDValueForKey:@"shop_id"];
            followContent.shop_name = [params arrayNameValueForKey:@"shop_id"];
            
            followContent.note = [params stringValueForKey:@"note"];

        }
        [dataManager deleteObjects:oldContentProducts];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberFollowContentResponse object:nil userInfo:dict];
}

@end
