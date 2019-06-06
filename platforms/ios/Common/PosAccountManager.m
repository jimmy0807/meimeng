//
//  PosAccountManager.m
//  Boss
//
//  Created by jimmy on 16/1/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PosAccountManager.h"

@implementation PosAccountManager

+ (void)setBLUserName:(NSString*)userName password:(NSString*)password
{
    [ICKeyChainManager storeUsername:@"PosBLUserName" andPassword:userName forServiceName:IC_DEFAULT_SERVICE_NAME];
    [ICKeyChainManager storeUsername:@"PosBLPassword" andPassword:password forServiceName:IC_DEFAULT_SERVICE_NAME];
}

+ (void)setAudioUserName:(NSString*)userName password:(NSString*)password
{
    [ICKeyChainManager storeUsername:@"PosAudioUserName" andPassword:userName forServiceName:IC_DEFAULT_SERVICE_NAME];
    [ICKeyChainManager storeUsername:@"PosAudioPassword" andPassword:password forServiceName:IC_DEFAULT_SERVICE_NAME];
}

+ (void)deleteBLUserName
{
    [ICKeyChainManager deleteItemForUsername:@"PosBLUserName" forServiceName:IC_DEFAULT_SERVICE_NAME];
    [ICKeyChainManager deleteItemForUsername:@"PosBLPassword" forServiceName:IC_DEFAULT_SERVICE_NAME];
}

+ (void)deleteAudioUserName
{
    [ICKeyChainManager deleteItemForUsername:@"PosAudioUserName" forServiceName:IC_DEFAULT_SERVICE_NAME];
    [ICKeyChainManager deleteItemForUsername:@"PosAudioPassword" forServiceName:IC_DEFAULT_SERVICE_NAME];
}

+ (NSString*)getBLUserName
{
    return [ICKeyChainManager getPasswordForUsername:@"PosBLUserName" forServiceName:IC_DEFAULT_SERVICE_NAME];
}

+ (NSString*)getBLPassword
{
    return [ICKeyChainManager getPasswordForUsername:@"PosBLPassword" forServiceName:IC_DEFAULT_SERVICE_NAME];
}

+ (NSString*)getAudioUserName
{
    return [ICKeyChainManager getPasswordForUsername:@"PosAudioUserName" forServiceName:IC_DEFAULT_SERVICE_NAME];
}

+ (NSString*)getAudioPassword
{
    return [ICKeyChainManager getPasswordForUsername:@"PosAudioPassword" forServiceName:IC_DEFAULT_SERVICE_NAME];
}

@end
