//
//  HShoushuLineEditRequest.m
//  meim
//
//  Created by jimmy on 2017/5/11.
//
//

#import "HShoushuLineEditRequest.h"

typedef enum kMemberRequestType
{
    kMemberRequestCreate,
    kMemberRequestEdit
}kMemberRequestType;

@interface HShoushuLineEditRequest ()

@property (nonatomic, assign) kMemberRequestType type;
@property (nonatomic, strong) NSDictionary *params;
@end


@implementation HShoushuLineEditRequest

- (id)initWithShoushuID:(NSNumber *)shoushuID params:(NSDictionary *)params
{
    self = [super init];
    if (self != nil)
    {
        self.params = params;
        self.shoushuID = shoushuID;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.medical.operate.line";
    if ( self.shoushuID )
    {
        self.type = kMemberRequestEdit;
    }
    else
    {
        self.type = kMemberRequestCreate;
    }
    
    if (self.type == kMemberRequestCreate)
    {
        [self sendShopAssistantXmlCreateCommand:@[self.params]];
    }
    else if (self.type == kMemberRequestEdit)
    {
        [self sendShopAssistantXmlWriteCommand:@[@[self.shoushuID], self.params]];
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
                    memberID = self.shoushuID;
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHShoushuLineEditResponse object:self userInfo:params];
}

@end
