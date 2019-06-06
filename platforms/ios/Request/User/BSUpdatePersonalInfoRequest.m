//
//  BSUpdatePersonalInfoRequest.m
//  Boss
//
//  Created by mac on 15/7/3.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSUpdatePersonalInfoRequest.h"

@interface BSUpdatePersonalInfoRequest ()
@property(nonatomic, strong)NSDictionary* params;
@end

@implementation BSUpdatePersonalInfoRequest
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
    if ( !self.userID )
    {
        PersonalProfile *profile = [PersonalProfile currentProfile];
        self.userID = profile.userID;
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
