//
//  HHuizhenCreateRequest.m
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "HHuizhenCreateRequest.h"

typedef enum kMemberRequestType
{
    kMemberRequestCreate,
    kMemberRequestEdit
}kMemberRequestType;

@interface HHuizhenCreateRequest ()

@property (nonatomic, assign) kMemberRequestType type;
@property (nonatomic, strong) NSNumber *huizhenID;
@property (nonatomic, strong) NSDictionary *params;
@property(nonatomic)BOOL isEdit;
@end

@implementation HHuizhenCreateRequest

- (id)initWithHuizhenID:(NSNumber *)huizhenID params:(NSDictionary *)params isEdit:(BOOL)isEdit
{
    self = [super init];
    if (self != nil)
    {
        self.params = params;
        if ( [huizhenID integerValue] > 0 )
        {
            self.huizhenID = huizhenID;
            
        }
        self.isEdit = isEdit;
    }
    
    return self;
}

- (BOOL)willStart
{
    if ( self.isEdit )
    {
        self.tableName = @"born.medical.records.line";
    }
    else
    {
        self.tableName = @"born.medical.records";
    }
    
    self.type = kMemberRequestEdit;
    [self sendShopAssistantXmlWriteCommand:@[@[self.huizhenID], self.params]];
    
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
                    memberID = self.huizhenID;
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHHuizhenCreateResponse object:memberID userInfo:params];
}

@end
