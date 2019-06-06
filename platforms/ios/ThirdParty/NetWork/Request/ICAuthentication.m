//
//  ICAuthentication.m
//  BetSize
//
//  Created by jimmy on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICAuthentication.h"
#import "NSData+Additions.h"

@implementation ICAuthentication
@synthesize secret = _secret;

- (id)initWithToken: (NSString*)token userName: (NSString*)userName
{
    self = [super init];
    if (self)
    {
        NSString* orginal = [NSString stringWithFormat:@"%@:%@", userName, token];
        NSData* data_org = [orginal dataUsingEncoding:NSUTF8StringEncoding];
        _secret = [[NSString stringWithFormat:@"Basic %@", [data_org base64Encoding]] retain];
    }
    return self;
}

- (id)initWithICKeyChainToken:(NSString*)token userName:(NSString*)userName
{
    self = [super init];
    if (self)
    {
        self.secret = token;
        self.userName = userName;
    }
    return self;
}

- (void)dealloc
{
    //[_token release];
    [_secret release];
    [super dealloc];
}

- (void)saveToUserDefaults
{
    [ICKeyChainManager storeUsername:USER_Name andPassword:self.userName];
    [ICKeyChainManager storeUsername:USER_Token andPassword:self.secret];
}

+ (ICAuthentication*)authenticationFromUserDefaults
{
    NSString* secret = [ICKeyChainManager getPasswordForUsername:USER_Token];

    if ([secret length] == 0) 
    {
        return nil;
    }
    
    ICAuthentication* auth = [[[ICAuthentication alloc] init] autorelease];
    auth.secret = secret;
    auth.userName = [ICKeyChainManager getPasswordForUsername:USER_Name];
    return auth;
}

@end

