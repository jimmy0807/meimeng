//
//  UpdatePrintServerRequest.m
//  meim
//
//  Created by 波恩公司 on 2017/12/22.
//

#import "UpdatePrintServerRequest.h"

@implementation UpdatePrintServerRequest

- (id)initWithAttribute:(NSString *)attribute attributeName:(NSString *)attributeName
{
    self = [super init];
    if(self)
    {
        PersonalProfile *profile = [PersonalProfile currentProfile];
        self.userID = profile.userID;
        self.attribute = attribute;
        self.attributeName = attributeName;
    }
    return self;
}

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self)
    {
        self.params = params;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"res.users";
    if ( !self.params )
    {
        self.params = [NSDictionary dictionaryWithObjectsAndKeys:self.attribute, self.attributeName, nil];
    }
    
    [self sendShopAssistantXmlWriteCommand:@[@[self.userID], self.params]];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (resultStr.length != 0 && resultList != nil)
    {
        if ([resultList isKindOfClass:[NSNumber class]])
        {
            if([(NSNumber *)resultList  isEqual: @1])
            {
                [params setValue:@0 forKey:@"rc"];
                [params setValue:@0 forKey:@"rm"];
                [self.profile save];
            }
        }
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSUpdatePersonalInfoResponse object:self userInfo:params];
}

@end
