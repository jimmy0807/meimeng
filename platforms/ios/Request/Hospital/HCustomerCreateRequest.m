//
//  HCustomerCreateRequest.m
//  meim
//
//  Created by jimmy on 2017/4/13.
//
//

#import "HCustomerCreateRequest.h"

#import "ChineseToPinyin.h"

typedef enum kMemberRequestType
{
    kMemberRequestCreate,
    kMemberRequestEdit
}kMemberRequestType;

@interface HCustomerCreateRequest ()

@property (nonatomic, assign) kMemberRequestType type;
@property (nonatomic, strong) NSNumber *memberID;
@property (nonatomic, strong) NSDictionary *params;

@end


@implementation HCustomerCreateRequest

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
    self.tableName = @"born.medical.customer";
    if (self.type == kMemberRequestCreate)
    {
        [self sendShopAssistantXmlCreateCommand:@[self.params]];
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
            CDHCustomer *member = [[BSCoreDataManager currentManager] findEntity:@"CDHCustomer" withValue:memberID forKey:@"memberID"];
            if (member == nil)
            {
                member = [[BSCoreDataManager currentManager] insertEntity:@"CDHCustomer"];
                member.memberID = memberID;
                member.storeID = [[PersonalProfile currentProfile].shopIds firstObject];
            }
            
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
            
            if ([[self.params stringValueForKey:@"street"] length] != 0)
            {
                member.member_address = [self.params stringValueForKey:@"street"];
            }
            
            if ([[self.params stringValueForKey:@"note"] length] != 0)
            {
                member.remark = [self.params stringValueForKey:@"note"];
            }

            member.tuijian_kehu_id = [self.params numberValueForKey:@"parent_id"];
            CDHCustomer* c = [[BSCoreDataManager currentManager] findEntity:@"CDHCustomer" withValue:member.tuijian_kehu_id forKey:@"memberID"];
            member.tuijian_kehu_name = c.memberName;
            
            member.tuijian_member_id = [self.params numberValueForKey:@"recommend_member_id"];
            CDMember* m = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:member.tuijian_member_id forKey:@"memberID"];
            member.tuijian_member_name = m.memberName;
            
            member.partner_name_id = [self.params numberValueForKey:@"channel_id"];
            CDPartner* p = [[BSCoreDataManager currentManager] findEntity:@"CDPartner" withValue:member.tuijian_kehu_id forKey:@"partner_id"];
            member.partner_name = p.name;
            
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHCustomerCreateResponse object:memberID userInfo:params];
}

@end
