//
//  BSUserDefaultsManager.m
//  CardBag
//
//  Created by jimmy on 13-8-15.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import "BSUserDefaultsManager.h"
#import "BSCoreDataManager.h"

@implementation BSUserDefaultsManager

IMPSharedManager(BSUserDefaultsManager)

-(BOOL)rememberPassword
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* checkFlag = [userDefaults objectForKey:UD_RememberPassword];
    BOOL remembered = TRUE; //默认为选中（记住密码）
    if ( checkFlag )
    {
        remembered = [checkFlag boolValue];
    }
    
    return remembered;
}

-(void)setRememberPassword:(BOOL)flag
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:flag] forKey:UD_RememberPassword];
    [userDefaults synchronize];
}

-(BOOL)useBigPhoto
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* checkFlag = [userDefaults objectForKey:UD_UseBigPhoto];
    BOOL remembered = false;
    if ( checkFlag )
    {
        remembered = [checkFlag boolValue];
    }
    
    return remembered;
}

- (void)setUseBigPhoto:(BOOL)flag
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:flag] forKey:UD_UseBigPhoto];
    [userDefaults synchronize];
}

-(void)setSynDate:(NSString *)synDate
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:synDate forKey:UD_UserInfoSynDate];
    [userDefaults synchronize];
}

-(NSString *)synDate
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *dateString = [userDefaults stringForKey:UD_UserInfoSynDate];
    return dateString;
}

-(void)setIsHaveAlertSetPayPassword:(BOOL)isHaveAlertSetPayPassword
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:isHaveAlertSetPayPassword] forKey:UD_alertSetPayPassword];
    [userDefaults synchronize];
}
-(BOOL)isHaveAlertSetPayPassword
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *checkFlag = [userDefaults objectForKey:UD_alertSetPayPassword];
    BOOL flag = false;
    if (checkFlag) {
        flag = [checkFlag boolValue];
    }
    return flag;
}

-(void)setIsActivityCardRemoved:(BOOL)isActivityCardRemoved
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:isActivityCardRemoved] forKey:UD_isActivityCardRemoved];
    [userDefaults synchronize];
}

-(BOOL)isActivityCardRemoved
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *checkFlag = [userDefaults objectForKey:UD_isActivityCardRemoved];
    BOOL flag = false;
    if (checkFlag) {
        flag = [checkFlag boolValue];
    }
    return flag;
}

-(void)setIsAllowAccessABook:(BOOL)isAllowAccessABook
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:isAllowAccessABook] forKey:UD_isAllowAcessABook];
    [userDefaults synchronize];
}

-(BOOL)isAllowAccessABook
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *checkFlag = [userDefaults objectForKey:UD_isAllowAcessABook];
    BOOL flag = false;
    if (checkFlag) {
        flag = [checkFlag boolValue];
    }
    return flag;
}

-(void)setShowABookAlert:(BOOL)showABookAlert
{
    [CB_USER_DEFAULT setObject:[NSNumber numberWithBool:showABookAlert] forKey:UD_showABookAlert];
    [CB_USER_DEFAULT synchronize];
}

-(BOOL)showABookAlert
{
    NSNumber *checkFlag = [CB_USER_DEFAULT objectForKey:UD_showABookAlert];
    BOOL flag = false;
    if (checkFlag) {
        flag = [checkFlag boolValue];
    }
    
    return flag;
}


- (BOOL)hideAddCardProcess
{
    NSNumber *checkFlag = [CB_USER_DEFAULT objectForKey:UD_HideAddCardProcess];
    BOOL flag = NO;
    if (checkFlag)
    {
        flag = [checkFlag boolValue];
    }
    
    return flag;
}

- (void)setHideAddCardProcess:(BOOL)hideAddCardProcess
{
    [CB_USER_DEFAULT setObject:[NSNumber numberWithBool:hideAddCardProcess] forKey:UD_HideAddCardProcess];
    [CB_USER_DEFAULT synchronize];
}

- (NSDate *)lastRandomDate
{
    NSDate *checkDate = [CB_USER_DEFAULT objectForKey:UD_LastRequestDate];
    NSDate *date = nil;
    if (checkDate)
    {
        date = checkDate;
    }
    
    return date;
}

- (void)setLastRandomDate:(NSDate *)lastRandomDate
{
    [CB_USER_DEFAULT setObject:lastRandomDate forKey:UD_LastRequestDate];
    [CB_USER_DEFAULT synchronize];
}

- (NSDictionary *)mPadPrinterRecord
{
    NSDictionary *device = [CB_USER_DEFAULT objectForKey:UD_mPadPrinterRecord];
    if (device == nil)
    {
        device = [NSDictionary dictionary];
    }
    
    return device;
}

- (void)setMPadPrinterRecord:(NSDictionary *)mPadPrinterRecord
{
    [CB_USER_DEFAULT setObject:mPadPrinterRecord forKey:UD_mPadPrinterRecord];
    [CB_USER_DEFAULT synchronize];
}

- (BOOL)isPadProjectViewRemind
{
    NSNumber *checkFlag = [CB_USER_DEFAULT objectForKey:UD_ISPadProjectViewRemind];
    BOOL flag = NO;
    if (checkFlag)
    {
        flag = [checkFlag boolValue];
    }
    
    return flag;
}

- (void)setIsPadProjectViewRemind:(BOOL)isPadProjectViewRemind
{
    [CB_USER_DEFAULT setObject:[NSNumber numberWithBool:isPadProjectViewRemind] forKey:UD_ISPadProjectViewRemind];
    [CB_USER_DEFAULT synchronize];
}

- (NSDictionary *)mPadCodeScannerRecord
{
    NSDictionary *device = [CB_USER_DEFAULT objectForKey:UD_mPadCodeScannerRecord];
    if (device == nil)
    {
        device = [NSDictionary dictionary];
    }
    
    return device;
}

- (void)setMPadCodeScannerRecord:(NSDictionary *)mPadCodeScannerRecord
{
    [CB_USER_DEFAULT setObject:mPadCodeScannerRecord forKey:UD_mPadCodeScannerRecord];
    [CB_USER_DEFAULT synchronize];
}

- (NSDictionary *)mPadPosMachineRecord
{
    NSDictionary *device = [CB_USER_DEFAULT objectForKey:UD_mPadPosMachineRecord];
    if (device == nil)
    {
        device = [NSDictionary dictionary];
    }
    
    return device;
}

- (void)setMPadPosMachineRecord:(NSDictionary *)mPadPosMachineRecord
{
    [CB_USER_DEFAULT setObject:mPadPosMachineRecord forKey:UD_mPadPosMachineRecord];
    [CB_USER_DEFAULT synchronize];
}

- (void)setMPrintIP:(NSString *)mPrintIP
{
    [CB_USER_DEFAULT setObject:mPrintIP forKey:UD_mPrintIP];
    [CB_USER_DEFAULT synchronize];
}

- (NSString*)mPrintIP
{
    return [CB_USER_DEFAULT objectForKey:UD_mPrintIP];
}

@end
