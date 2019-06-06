//
//  BSSetDeviceTokenRequest.m
//  Boss
//
//  Created by jimmy on 15/8/13.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSSetDeviceTokenRequest.h"

@interface BSSetDeviceTokenRequest ()
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSDictionary *params;
@end

@implementation BSSetDeviceTokenRequest

- (id)initWithToken:(NSString *)token
{
    self = [super init];
    if (self)
    {
        self.token = token;
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

-(BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    if ( ![profile.isLogin boolValue] )
    {
        return FALSE;
    }
    
    if ( self.params )
    {
        [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"jpush_token" params:@[self.params]];
    }
    else
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.token, @"token", profile.userID, @"uid", nil];
        
        [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"token" params:@[params]];
    }
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    
}

@end
