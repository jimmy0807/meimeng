//
//  HMemberVisitCreateRequest.m
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "HMemberVisitCreateRequest.h"
#import "ChineseToPinyin.h"

typedef enum kMemberRequestType
{
    kMemberRequestCreate,
    kMemberRequestEdit
}kMemberRequestType;

@interface HMemberVisitCreateRequest ()

@property (nonatomic, assign) kMemberRequestType type;
@property (nonatomic, strong) NSNumber *visitID;
@property (nonatomic, strong) NSDictionary *params;

@end


@implementation HMemberVisitCreateRequest

- (id)initWithVisitID:(NSNumber *)visitID params:(NSDictionary *)params
{
    self = [super init];
    if (self != nil)
    {
        self.params = params;
        if ( [visitID integerValue] > 0 )
        {
            self.visitID = visitID;
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
    self.tableName = @"born.member.visit";
    if (self.type == kMemberRequestCreate)
    {
        [self sendShopAssistantXmlCreateCommand:@[self.params]];
    }
    else if (self.type == kMemberRequestEdit)
    {
        [self sendShopAssistantXmlWriteCommand:@[@[self.visitID], self.params]];
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
                    memberID = self.visitID;
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHMemberVisitCreateResponse object:memberID userInfo:params];
}

@end
