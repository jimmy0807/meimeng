//
//  ICRequestManager.m
//  BetSize
//
//  Created by jimmy on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICRequestManager.h"

static ICRequestManager* s_sharedMananger;

@implementation ICRequestManager
@synthesize requests;

- (id)init
{
    self = [super init];
    if (self) 
    {
        requests = [[NSMutableArray alloc] init];
        _locker = [[NSRecursiveLock alloc] init];
        _auth = [[ICAuthentication authenticationFromUserDefaults] retain];
        //[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(didReceiveAuth:) name:kICRegisterResponse object: nil];
        //[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(didReceiveAuth:) name:kICChangePasswordResponse object: nil];
    }
    return self;
}

- (void)dealloc
{
    //[[NSNotificationCenter defaultCenter] removeObserver: self name: kICRegisterResponse object: nil];
    //[[NSNotificationCenter defaultCenter] removeObserver: self name: kICChangePasswordResponse object: nil];
    [_auth release];
    [requests release];
    [_locker release];
    [super dealloc];
}

+ (ICRequestManager*)sharedManager
{
    @synchronized(s_sharedMananger)
    {
        if (s_sharedMananger == nil) 
        {
            s_sharedMananger = [[ICRequestManager alloc] init];
        }
    }
    return  s_sharedMananger;
}

- (void) cancelAllRequests
{
    [_locker lock];
    for (ICRequest* rq in requests) 
    {
        [rq cancel];
    }
    [requests removeAllObjects];
    [_locker unlock];
}

- (void)addRequest: (ICRequest*)request
{
    [_locker lock];
    request.auth = _auth;
    [requests addObject: request];
    [_locker unlock];
}

- (void)removeRequest: (ICRequest*)request
{
    [_locker lock];
    [requests removeObject: request];
    [_locker unlock];
}

- (void)didReceiveAuth: (NSNotification*)notification
{
    SAFE_RELEASE(_auth);
    NSDictionary* paramDict = (NSDictionary*)[notification userInfo];
    [self saveToken:paramDict];
}

- (void)saveToken:(NSString*)token userName:(NSString*)userName
{
    ICAuthentication* auth = [[ICAuthentication alloc] initWithICKeyChainToken: token userName: userName];
    _auth = auth;
    [_auth saveToUserDefaults];
}

- (void)saveToken: (NSDictionary*)paramDict
{
    NSString* result = [paramDict objectForKey: @"result"];
    if ([result isEqualToString:@"ok"]) 
    {
        NSString* token = [paramDict objectForKey: @"token"];
        NSString* username = [paramDict objectForKey: @"username"];
        ICAuthentication* auth = [[ICAuthentication alloc] initWithICKeyChainToken: token userName: username];
        _auth = auth;
        [_auth saveToUserDefaults];
    }
}

@end
