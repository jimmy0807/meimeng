//
//  HZixundanCreateRequest.m
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "HZixundanCreateRequest.h"
#import "ChineseToPinyin.h"

typedef enum kMemberRequestType
{
    kMemberRequestCreate,
    kMemberRequestEdit
}kMemberRequestType;

@interface HZixundanCreateRequest ()

@property (nonatomic, assign) kMemberRequestType type;
@property (nonatomic, strong) NSNumber *memberID;
@property (nonatomic, strong) NSDictionary *params;

@end


@implementation HZixundanCreateRequest

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
        if ( [memberId integerValue] > 0 )
        {
            self.memberID = memberId;
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
    self.tableName = @"born.medical.advisory";
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHZixunCreateResponse object:memberID userInfo:params];
}

@end
