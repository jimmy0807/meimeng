//
//  BNCheckNewVersionManager.m
//  Boss
//
//  Created by jimmy on 15/9/8.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BNCheckNewVersionManager.h"
#import "ICKeyChainManager.h"
#import "NSDictionary+JSON.h"

//{"appname":"微卡","apkname":"wevip.apk","verName":"1.0.1","verCode":16,"forceUpdate":"0","verInfo":"1.修复了某些情况下 账单金额显示不正确的问题"}
@interface BNCheckNewVersionManager ()
@property(nonatomic, strong)NSURLConnection* connection;
@property(nonatomic, strong)NSMutableData* receivedData;
@property(nonatomic, strong)NSString* forceUpdate;
@end

@implementation BNCheckNewVersionManager

IMPSharedManager(BNCheckNewVersionManager)

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *identifier = [infoDict objectForKey:@"CFBundleIdentifier"];
        if ( ![identifier isEqualToString:@"com.born.boss"] )
        {
            return self;
        }
        
        self.serverVersion = [ICKeyChainManager getPasswordForUsername:@"server_version" forServiceName:IC_DEFAULT_SERVICE_NAME];
        self.versionDescription = [ICKeyChainManager getPasswordForUsername:@"server_verInfo" forServiceName:IC_DEFAULT_SERVICE_NAME];
        self.forceUpdate = [ICKeyChainManager getPasswordForUsername:@"server_forceUpdate" forServiceName:IC_DEFAULT_SERVICE_NAME];
        
        self.localVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    }
    
    return self;
}

- (BOOL)hasNewVersion
{
    if ( [self.forceUpdate integerValue] == 1 && IS_IPAD )
    {
        return FALSE;
    }
    
    if ( [self.forceUpdate integerValue] == 2 && !IS_IPAD )
    {
        return FALSE;
    }
    
    return ![self.serverVersion isEqualToString:self.localVersion];
}

- (BOOL)isNeedForceUpdate
{
    if ( [self.forceUpdate integerValue] == 111 && !IS_IPAD )
    {
        return TRUE;
    }
    
    if ( [self.forceUpdate integerValue] == 2222 && IS_IPAD )
    {
        return TRUE;
    }
    
    return FALSE;
}

- (void)fetchServerVersion
{
#if 0
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *identifier = [infoDict objectForKey:@"CFBundleIdentifier"];
    if ( ![identifier isEqualToString:@"com.born.boss"] )
    {
        return;
    }
    
    NSString* baserUrl = @"http://api.fir.im/apps/latest/56305f09e75e2d39f500000a?api_token=5af3b4bae863351a5e9cb3f4e1127f84";
    NSURLRequest* rq = [NSURLRequest requestWithURL:[NSURL URLWithString:baserUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    self.connection = [NSURLConnection connectionWithRequest:rq delegate: self];
    self.receivedData = [NSMutableData data];
#endif
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData: data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.connection = nil;
    NSDictionary* params = [NSDictionary dictionaryWithJSONData:self.receivedData];
    if ( params )
    {
        self.serverVersion = [params objectForKey:@"versionShort"];
        self.versionDescription = [params stringValueForKey:@"changelog"];
        self.forceUpdate = [params objectForKey:@"version"];
        
        //111 强制iphone 222 强制 iPad   1 iPhone  2 iPad
        if ( [self isNeedForceUpdate] && [self hasNewVersion] )
        {
            [self performSelector:@selector(delayToAlert) withObject:nil afterDelay:2];
        }
        
        [ICKeyChainManager storeUsername:@"server_version" andPassword:self.serverVersion forServiceName:IC_DEFAULT_SERVICE_NAME];
        [ICKeyChainManager storeUsername:@"server_verInfo" andPassword:self.versionDescription forServiceName:IC_DEFAULT_SERVICE_NAME];
        [ICKeyChainManager storeUsername:@"server_forceUpdate" andPassword:self.forceUpdate forServiceName:IC_DEFAULT_SERVICE_NAME];
    }
    
    self.receivedData = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCheckNewVersionResponse object:nil userInfo:nil];
}

- (void)delayToAlert
{
    UIAlertView* view = [[UIAlertView alloc] initWithTitle:@"您必须更新才能继续运行" message:self.versionDescription delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [view show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 )
    {
        [self update];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.connection = nil;
    self.receivedData = nil;
    if ( [self isNeedForceUpdate] && [self hasNewVersion] )
    {
        [self performSelector:@selector(delayToAlert) withObject:nil afterDelay:2];
    }
}

- (void)update
{
#if 0
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://fir.im/boss"]];
#endif
    exit(0);
}

@end
