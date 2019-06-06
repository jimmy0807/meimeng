//
//  PayBankManager.m
//  Boss
//
//  Created by jimmy on 16/1/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PayBankManager.h"
#import "PosAccountManager.h"

@implementation PayBankManager

IMPSharedManager(PayBankManager)

- (void)payWithAccountType:(PayBankAccountType)type price:(NSString*)price device:(NSString *)device bankNo:(NSString*)bankNo delegate:(id<PayBankManagerDelegate>)delegate
{
    self.delegate = delegate;
    
    NSString* userName = (type == PayBankAccountType_BlueTooth ) ? [PosAccountManager getBLUserName] : [PosAccountManager getAudioUserName];
    NSString* password = (type == PayBankAccountType_BlueTooth ) ? [PosAccountManager getBLPassword] : [PosAccountManager getAudioPassword];
    
    if ( userName.length == 0 || password.length == 0 )
    {
        [self.delegate pleaseSetUserName:type];
        return;
    }
    
    //device = @"UPOS15122200019"; //｛1横、0竖｝
    //倒数第二个 0代表交易  1代表撤销
    
    NSString *urlString = [NSString stringWithFormat:@"com.vepos.wyzft://%@,%@,%@,%d,%@,%@,%d,%@",userName, password,price, IS_IPAD?1:0, @"PosBoss", device,bankNo.length>0?1:0, bankNo.length>0?bankNo:@""];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]])
    {
        if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:LS(@"请先确认是否已信任手机Pos专家")
                                                               delegate:nil
                                                      cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else
    {
        [self.delegate pleaseInstallVePos];
    }
}

- (void)handleOpenURL:(NSURL *)url
{
    NSString* host = url.host;
    NSArray* responseArray = [host componentsSeparatedByString:@","];
    NSString *resultCode = @"";
    if ( responseArray.count >= 2 )
    {
        resultCode = responseArray[1];
    }
    
    if ([resultCode isEqualToString:@"00"])
    {
        NSString* bankNo = @"";
        if ( responseArray.count == 3 )
        {
            bankNo = responseArray[2];
        }
        
        [self.delegate tradeSuccess:bankNo];
    }
    else
    {
        [self.delegate tradeFailed:responseArray[0]];
    }
}

@end
