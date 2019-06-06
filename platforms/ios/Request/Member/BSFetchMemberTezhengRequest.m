//
//  BSFetchMemberTezhengRequest.m
//  Boss
//
//  Created by lining on 16/3/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchMemberTezhengRequest.h"

@interface BSFetchMemberTezhengRequest ()
@property (nonatomic, strong) CDMember *member;
@end

@implementation BSFetchMemberTezhengRequest
- (instancetype)initWithMember:(CDMember *)member
{
    self = [super init];
    if (self) {
        self.member = member;
    }
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.extended.line";
    self.filter = @[@[@"member_id",@"=",self.member.memberID]];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if ([resultArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *tzAry = [NSMutableArray arrayWithArray:[dataManager fetchMemberTezhengWithMember:self.member]];
        for (NSDictionary *params in resultArray) {
            NSNumber *tz_id = [params numberValueForKey:@"id"];
            CDMemberTeZheng *tezheng = [dataManager findEntity:@"CDMemberTeZheng" withValue:tz_id forKey:@"tz_id"];
            if (tezheng == nil) {
                tezheng = [dataManager insertEntity:@"CDMemberTeZheng"];
                tezheng.tz_id = tz_id;
            }
            else
            {
                [tzAry removeObject:tezheng];
            }
            tezheng.tz_name = [params stringValueForKey:@"display_name"];
            tezheng.tz_describle = [params stringValueForKey:@"description"];
            
            NSNumber *extend_id = [params arrayIDValueForKey:@"extended_id"];
            CDExtend *extend = [dataManager uniqueEntityForName:@"CDExtend" withValue:extend_id forKey:@"extend_id"];
            extend.extend_name = [params arrayNameValueForKey:@"extended_id"];
            tezheng.extend = extend;

            tezheng.member_id = [params arrayIDValueForKey:@"member_id"];
            tezheng.member_name = [params arrayNameValueForKey:@"member_id"];
            tezheng.member = self.member;
        }
        
        [dataManager deleteObjects:tzAry];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"特征请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberTezhengResponse object:nil userInfo:dict];
}

@end
