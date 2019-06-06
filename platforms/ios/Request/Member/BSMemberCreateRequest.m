//
//  BSMemberCreateRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/10/29.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSMemberCreateRequest.h"
#import "ChineseToPinyin.h"
#import "BSFetchMemberDetailReqeustN.h"

typedef enum kMemberRequestType
{
    kMemberRequestCreate,
    kMemberRequestEdit
}kMemberRequestType;

@interface BSMemberCreateRequest ()

@property (nonatomic, assign) kMemberRequestType type;
@property (nonatomic, strong) NSNumber *memberID;
@property (nonatomic, strong) NSDictionary *params;

@end


@implementation BSMemberCreateRequest

- (id)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self != nil)
    {
        self.params = params;
        self.type = kMemberRequestCreate;
    }
    
    return self;
}

- (id)initWithMemberID:(NSNumber *)memberId params:(NSDictionary *)params
{
    self = [super init];
    if (self != nil)
    {
        self.params = params;
        self.memberID = memberId;
        self.type = kMemberRequestEdit;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.member";
    if (self.type == kMemberRequestCreate)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.params];
        [dict setObject:[[PersonalProfile currentProfile] bshopId] forKey:@"shop_id"];
        [self sendShopAssistantXmlCreateCommand:@[dict]];
    }
    else if (self.type == kMemberRequestEdit)
    {
        [self sendShopAssistantXmlWriteCommand:@[@[self.memberID], self.params]];
    }
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSNumber *memberID = nil;
    if (resultStr.length != 0)
    {
        if (self.type == kMemberRequestEdit)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                NSNumber *isSuccess = (NSNumber *)resultList;
                if (isSuccess.boolValue)
                {
                    memberID = self.memberID;
                }
            }
        }
        else if (self.type == kMemberRequestCreate)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                memberID = (NSNumber *)resultList;
            }
        }
        
        if (memberID.integerValue != 0)
        {
            CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:memberID forKey:@"memberID"];
            if (member == nil)
            {
                member = [[BSCoreDataManager currentManager] insertEntity:@"CDMember"];
                member.memberID = memberID;
                member.isDefaultCustomer = [NSNumber numberWithBool:NO];
                member.storeID = [[PersonalProfile currentProfile].shopIds firstObject];
            }
            
//            member.memberName = @"";
//            member.memberNameFirstLetter = @"";
//            member.memberNameLetter = @"";
//            member.memberNameSingleLetter = @"";
            if ([[self.params stringValueForKey:@"name"] length] != 0)
            {
                member.memberName = [self.params stringValueForKey:@"name"];
                
                member.memberNameLetter = [ChineseToPinyin pinyinFromChiniseString:member.memberName];
                member.memberNameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:member.memberName] uppercaseString];
                if (member.memberNameFirstLetter.length != 0)
                {
                    NSString *singleLetter = [member.memberNameFirstLetter substringToIndex:1];
                    if ([ChineseToPinyin isFirstLetterValidate:singleLetter])
                    {
                        member.memberNameSingleLetter = singleLetter;
                    }
                    else
                    {
                        member.memberNameSingleLetter = @"a";
                    }
                }
                else
                {
                    member.memberNameSingleLetter = @"a";
                }
            }
            
            if ([[self.params stringValueForKey:@"gender"] length] != 0)
            {
                member.gender = [self.params stringValueForKey:@"gender"];
            }
            if ([[self.params stringValueForKey:@"birth_date"] length] != 0)
            {
                member.birthday = [self.params stringValueForKey:@"birth_date"];
            }
            if ([[self.params stringValueForKey:@"mobile"] length] != 0)
            {
                member.mobile = [self.params stringValueForKey:@"mobile"];
            }
            if ([self.params objectForKey:@"image"] != nil)
            {
                ;
            }
            if ([[self.params stringValueForKey:@"qq"] length] != 0)
            {
                member.member_qq = [self.params stringValueForKey:@"qq"];
            }
            if ([[self.params stringValueForKey:@"wx"] length] != 0)
            {
                member.member_wx = [self.params stringValueForKey:@"wx"];
            }
            if ([[self.params stringValueForKey:@"email"] length] != 0)
            {
                member.email = [self.params stringValueForKey:@"email"];
            }
            if ([[self.params stringValueForKey:@"id_card_no"] length] != 0)
            {
                member.idCardNumber = [self.params stringValueForKey:@"id_card_no"];
            }
            if ([[self.params stringValueForKey:@"street"] length] != 0)
            {
                member.member_address = [self.params stringValueForKey:@"street"];
            }
            if ([[self.params stringValueForKey:@"is_ad"] length] != 0)
            {
                member.isTiyan = [self.params numberValueForKey:@"is_ad"];
            }
//            if ([[self.params stringValueForKey:@"image"] length] != 0)
//            {
//                member = [self.params stringValueForKey:@"image"];
//            }
            
            BSFetchMemberDetailRequestN* request = [[BSFetchMemberDetailRequestN alloc] initWithMemberID:member.memberID];
            [request execute];
            
            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            params = [self generateResponse:@"服务器异常, 请稍后重试"];
        }
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSMemberCreateResponse object:memberID userInfo:params];
}

@end
