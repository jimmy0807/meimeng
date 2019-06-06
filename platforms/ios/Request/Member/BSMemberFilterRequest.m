//
//  BSSearchMemberRequest.m
//  Boss
//
//  Created by lining on 16/5/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSMemberFilterRequest.h"
#import "PersonalProfile.h"

@interface BSMemberFilterRequest ()
@property (nonatomic, strong) NSMutableDictionary *params;
@end

@implementation BSMemberFilterRequest

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        if (params == nil) {
            self.params = [NSMutableDictionary dictionary];
        }
        else
        {
            self.params = [NSMutableDictionary dictionaryWithDictionary:params];
        }
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    PersonalProfile* profile = [PersonalProfile currentProfile];
    
    [self.params setObject:profile.businessId forKey:@"company_id"];
    NSMutableArray* sendArray = [NSMutableArray arrayWithObjects:profile.sql,profile.userID,self.params,nil];
    
    [self sendCustomRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"search_member" params:sendArray];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSDictionary *retDict = (NSDictionary *)[BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *filterMembers = [NSMutableArray array];
    if ( [retDict isKindOfClass:[NSDictionary class]])
    {
        int errCode = [[retDict numberValueForKey:@"errcode"] integerValue];
        NSString *errMsg = [retDict stringValueForKey:@"errmsg"];
        if (errCode == 0) {
            NSArray *dataArray = [retDict objectForKey:@"data"];
            BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
            for (NSDictionary *params in dataArray) {
                NSNumber *member_id = [params numberValueForKey:@"id"];
                CDMember *member = [dataManager uniqueEntityForName:@"CDMember" withValue:member_id forKey:@"memberID"];
                member.memberName = [params stringValueForKey:@"name"];
            
                member.mobile = [params stringValueForKey:@"mobile"];
                member.imageName = [NSString stringWithFormat:@"%@_%@",member_id, member.memberName];
                [filterMembers addObject:member];
            }
            [dataManager save:nil];
        }
        else
        {
            dict = [self generateResponse:errMsg];
        }
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFilterMemberResponse object:filterMembers userInfo:dict];
}

@end
