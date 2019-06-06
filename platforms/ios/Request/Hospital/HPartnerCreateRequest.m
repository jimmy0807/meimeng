//
//  HPartnerCreateRequest.m
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "HPartnerCreateRequest.h"
#import "ChineseToPinyin.h"

typedef enum kMemberRequestType
{
    kMemberRequestCreate,
    kMemberRequestEdit
}kMemberRequestType;

@interface HPartnerCreateRequest ()

@property (nonatomic, assign) kMemberRequestType type;
@property (nonatomic, strong) NSNumber *partnerID;
@property (nonatomic, strong) NSDictionary *params;

@end


@implementation HPartnerCreateRequest

- (id)initWithPartnerID:(NSNumber *)partnerID params:(NSDictionary *)params
{
    self = [super init];
    if (self != nil)
    {
        self.params = params;
        if ( [partnerID integerValue] > 0 )
        {
            self.partnerID = partnerID;
            self.type = kMemberRequestEdit;
        }
        else
        {
            self.type = kMemberRequestCreate;
        }
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.partner";
    if (self.type == kMemberRequestCreate)
    {
        [self sendShopAssistantXmlCreateCommand:@[self.params]];
    }
    else if (self.type == kMemberRequestEdit)
    {
        [self sendShopAssistantXmlWriteCommand:@[@[self.partnerID], self.params]];
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
                    memberID = self.partnerID;
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHPartnerCreateResponse object:memberID userInfo:params];
}

@end
