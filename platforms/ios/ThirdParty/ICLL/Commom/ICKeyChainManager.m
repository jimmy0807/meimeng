//
//  ICKeyChainManager.m
//  BetSize
//
//  Created by jimmy on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICKeyChainManager.h"

static NSString* currentServiceName = nil;

@implementation ICKeyChainManager
+(void)setCurrentServiceName:(NSString*)serviceName
{
    if ( currentServiceName )
    {
        [currentServiceName release];
    }
    currentServiceName = [serviceName retain];
}

+(NSString*)getCurrentServiceName
{
    return currentServiceName;
}

+(BOOL)storeUsername:(NSString*)username andPassword:(NSString*)password
{
    return [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:currentServiceName?currentServiceName:IC_DEFAULT_SERVICE_NAME updateExisting:YES error:nil];
}

+(NSString*)getPasswordForUsername:(NSString*)username
{
    return [SFHFKeychainUtils getPasswordForUsername:username andServiceName:currentServiceName?currentServiceName:IC_DEFAULT_SERVICE_NAME error:nil];
}

+(BOOL) deleteItemForUsername:(NSString*)username
{
    return [SFHFKeychainUtils deleteItemForUsername:username andServiceName:currentServiceName?currentServiceName:IC_DEFAULT_SERVICE_NAME error:nil];
}

+(BOOL)storeUsername:(NSString*)username andPassword:(NSString*)password forServiceName:(NSString*)serviceName
{
    return [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:serviceName updateExisting:YES error:nil];
}

+(NSString*)getPasswordForUsername:(NSString*)username forServiceName:(NSString*)serviceName
{
    return [SFHFKeychainUtils getPasswordForUsername:username andServiceName:serviceName error:nil];
}

+(BOOL) deleteItemForUsername:(NSString*)username forServiceName:(NSString*)serviceName
{
    return [SFHFKeychainUtils deleteItemForUsername:username andServiceName:serviceName error:nil];
}

@end
