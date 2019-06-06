//
//  BSFetchUsers.m
//  Boss
//
//  Created by mac on 15/7/9.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchUsers.h"

@implementation BSFetchUsers

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"res.users";
    self.field = @[@"id", @"name", @"login"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSArray *userList = [dataManager fetchAllUser];
        NSMutableArray *oldUserList = [NSMutableArray arrayWithArray:userList];
        for (NSDictionary *params in retArray)
        {
            NSString *user_id = [params stringValueForKey:@"id"];
            CDUser *user = [dataManager findEntity:@"CDUser" withValue:user_id forKey:@"user_id"];
            if (user == nil)
            {
                user = [dataManager insertEntity:@"CDUser"];
                user.user_id = [NSNumber numberWithInteger:[user_id integerValue]];
            }
            else
            {
                [oldUserList removeObject:user];
            }
            user.name = [params stringValueForKey:@"name"];
            user.mobile = [params stringValueForKey:@"login"];
        }
        [dataManager deleteObjects:oldUserList];
        [dataManager save:nil];
        
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"rc"];
        [dict setObject:@"" forKey:@"rm"];
        [dict setObject:retArray forKey:@"data"];
    }
    else
    {
        dict = [self generateResponse:@"请求发生错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchUsersResponse object:nil userInfo:dict];
}

@end

