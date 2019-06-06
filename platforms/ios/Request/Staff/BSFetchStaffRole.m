//
//  BSFetchStaffPermission.m
//  Boss
//
//  Created by lining on 15/7/13.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "CDStaffRole.h"
#import "BSFetchStaffRole.h"

@implementation BSFetchStaffRole
- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"res.users";
    self.filter = @[@[@"active",@"=",@false],@[@"approved",@"=",@"approved"]];
    self.field = @[@"name"];
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if ([retArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSArray *oldArray = [dataManager fetchItems:@"CDStaffRole" sortedByKey:@"roleID" ascending:YES];
        NSMutableArray *roleArray = [[NSMutableArray alloc]initWithArray:oldArray];
        for (NSDictionary *params in retArray)
        {
            NSNumber *ID = [params numberValueForKey:@"id"];
            CDStaffRole *role = [dataManager findEntity:@"CDStaffRole" withValue:ID forKey:@"roleID"];
            if(role)
            {
                [roleArray removeObject:role];
            }else
            {
                role = [dataManager insertEntity:@"CDStaffRole"];
                role.roleID = ID;
            }
            role.roleName = [params stringValueForKey:@"name"];
        }
        
        [dataManager deleteObjects:roleArray];
        [dataManager save:nil];
        [dict setObject:@0 forKey:@"rc"];
    }
    else
    {
        dict = [self generateResponse:@"请求发生错误"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchStaffPermission object:nil userInfo:dict];
}

@end
