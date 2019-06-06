//
//  ICKeyChainManager.h
//  BetSize
//
//  Created by jimmy on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFHFKeychainUtils.h"

#define IC_DEFAULT_SERVICE_NAME @"IC_SERVICE_NAME" //用来做全局的存储

@interface ICKeyChainManager : NSObject
+(void)setCurrentServiceName:(NSString*)serviceName;
+(NSString*)getCurrentServiceName;

+(BOOL)storeUsername:(NSString*)username andPassword:(NSString*)password;
+(NSString*)getPasswordForUsername:(NSString*)username;
+(BOOL) deleteItemForUsername:(NSString*)username;

+(BOOL)storeUsername:(NSString*)username andPassword:(NSString*)password forServiceName:(NSString*)serviceName;
+(NSString*)getPasswordForUsername:(NSString*)username forServiceName:(NSString*)serviceName;
+(BOOL) deleteItemForUsername:(NSString*)username forServiceName:(NSString*)serviceName;

@end
