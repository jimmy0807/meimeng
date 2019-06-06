//
//  BSPersonalInfo.m
//  Boss
//
//  Created by mac on 15/7/1.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSPersonalInfoRequest.h"

@implementation BSPersonalInfoRequest
- (id)initWithPersonalUserID:(NSNumber *)userID
{
    self = [super init];
    if(self)
    {
        self.userID = userID;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.filter = @[@[@"id",@"=",self.userID]];
    self.field =  @[@"name",@"email",@"login",@"write_date"];
    self.tableName = @"res.users";
    [self sendShopAssistantXmlSearchReadCommand];
    return YES;
}

- (void)didFinishOnMainThread
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    if ([resultArray isKindOfClass:[NSArray class]])
    {
        PersonalProfile *profile = [PersonalProfile currentProfile];
        for(NSDictionary *para in resultArray)
        {
            profile.email = [para stringValueForKey:@"email"];
            profile.name = [para stringValueForKey:@"name"];
            profile.userName = [para stringValueForKey:@"login"];
            profile.writeDate = [para stringValueForKey:@"write_date"];
        }
        [profile save];
        [dict setObject:@0 forKey:@"rc"];
        [dict setObject:@"" forKey:@"rm"];
        [dict setObject:resultArray forKey:@"data"];
    }
    else
    {
        dict = [self generateResponse:@"请求发生错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPersonalInfoResponse object:self userInfo:dict];
}

@end
