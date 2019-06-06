//
//  PadCashRegisterView.m
//  Boss
//
//  Created by XiaXianBing on 16/1/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadCashRegisterView.h"
#import "PosAccountManager.h"
#import "CBLoadingView.h"
#import "PadProjectConstant.h"
#import "BSUserDefaultsManager.h"
#import "NSString+Additions.h"

@interface PadCashRegisterView ()

@property (nonatomic, strong) UIButton *wholeButton;
@property (nonatomic, strong) UIButton *bluetoothButton;

@property (nonatomic, assign) BOOL isWholeSelect;
@property (nonatomic, assign) BOOL isBluetoothSelect;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, strong) CDPOSPayMode *paymode;

@end


@implementation PadCashRegisterView

- (id)initWithPaymode:(CDPOSPayMode *)paymode amount:(CGFloat)amount
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT)];
    if (self)
    {
        self.amount = amount;
        self.paymode = paymode;
        
        self.bluetoothButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bluetoothButton.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH/2.0, IC_SCREEN_HEIGHT);
        [self.bluetoothButton setBackgroundImage:[UIImage imageNamed:@"pay_account_bluetooth_n"] forState:UIControlStateNormal];
        [self.bluetoothButton setBackgroundImage:[UIImage imageNamed:@"pay_account_bluetooth_h"] forState:UIControlStateHighlighted];
        [self.bluetoothButton addTarget:self action:@selector(didBluetoothButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bluetoothButton];
        
        self.wholeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.wholeButton.frame = CGRectMake(IC_SCREEN_WIDTH/2.0, 0.0, IC_SCREEN_WIDTH/2.0, IC_SCREEN_HEIGHT);
        [self.wholeButton setBackgroundImage:[UIImage imageNamed:@"pay_account_whole_n"] forState:UIControlStateNormal];
        [self.wholeButton setBackgroundImage:[UIImage imageNamed:@"pay_account_whole_h"] forState:UIControlStateHighlighted];
        [self.wholeButton addTarget:self action:@selector(didWholeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.wholeButton];
        
        UIImage *backImage = [UIImage imageNamed:@"pad_navi_back_n"];
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.backgroundColor = [UIColor clearColor];
        backButton.frame = CGRectMake(0.0, 0.0, backImage.size.width + 20.0, backImage.size.height);
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, backImage.size.width, backImage.size.height)];
        backImageView.backgroundColor = [UIColor clearColor];
        backImageView.image = backImage;
        [backButton addSubview:backImageView];
        UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(backImage.size.width - 24.0, 0.0, 44.0, backButton.frame.size.height)];
        backLabel.backgroundColor = [UIColor clearColor];
        backLabel.textAlignment = NSTextAlignmentLeft;
        backLabel.font = [UIFont boldSystemFontOfSize:17.0];
        backLabel.textColor = COLOR(169.0, 205.0, 205.0, 1.0);
        backLabel.text = LS(@"GoBack");
        [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [backButton addSubview:backLabel];
        [self addSubview:backButton];
    }
    
    return self;
}


#pragma mark -
#pragma mark Required Methods

- (void)refresh
{
//    self.isWholeSelect = NO;
//    [self.wholeButton setBackgroundImage:[UIImage imageNamed:@"pay_account_whole_n"] forState:UIControlStateNormal];
//    [self.wholeButton setBackgroundImage:[UIImage imageNamed:@"pay_account_whole_n"] forState:UIControlStateHighlighted];
//    
//    self.isBluetoothSelect = NO;
//    [self.bluetoothButton setBackgroundImage:[UIImage imageNamed:@"pay_account_bluetooth_n"] forState:UIControlStateNormal];
//    [self.bluetoothButton setBackgroundImage:[UIImage imageNamed:@"pay_account_bluetooth_n"] forState:UIControlStateHighlighted];
}

- (void)didBackButtonClick:(id)sender
{
    [self removeFromSuperview];
}

- (void)didBluetoothButtonClick:(id)sender
{
//    if (!self.isBluetoothSelect)
//    {
//        if (self.isWholeSelect)
//        {
//            self.isWholeSelect = NO;
//            [self.wholeButton setBackgroundImage:[UIImage imageNamed:@"pay_account_whole_n"] forState:UIControlStateNormal];
//            [self.wholeButton setBackgroundImage:[UIImage imageNamed:@"pay_account_whole_n"] forState:UIControlStateHighlighted];
//        }
//    }
    
    self.isBluetoothSelect = TRUE;
    
    if ([PosAccountManager getBLUserName].length == 0 || [PosAccountManager getBLPassword].length == 0)
    {
        [self.delegate didPadSettingWithType:kPadSettingViewPayAccount];
        return;
    }
    
    NSDictionary *dict = [BSUserDefaultsManager sharedManager].mPadPrinterRecord;
    NSString *device = [dict objectForKey:@"name"];
    if (device.length == 0)
    {
        [self.delegate didPadSettingWithType:kPadSettingViewPosMachine];
        return;
    }
    
//    self.isBluetoothSelect = !self.isBluetoothSelect;
//    if (self.isBluetoothSelect)
//    {
//        [self.bluetoothButton setBackgroundImage:[UIImage imageNamed:@"pay_account_bluetooth_h"] forState:UIControlStateNormal];
//        [self.bluetoothButton setBackgroundImage:[UIImage imageNamed:@"pay_account_bluetooth_h"] forState:UIControlStateHighlighted];
//    }
//    else
//    {
//        [self.bluetoothButton setBackgroundImage:[UIImage imageNamed:@"pay_account_bluetooth_n"] forState:UIControlStateNormal];
//        [self.bluetoothButton setBackgroundImage:[UIImage imageNamed:@"pay_account_bluetooth_n"] forState:UIControlStateHighlighted];
//    }
    
    if ([PosAccountManager getBLUserName].length != 0 && [PosAccountManager getBLPassword].length != 0 && device.length != 0)
    {
        [[PayBankManager sharedManager] payWithAccountType:PayBankAccountType_BlueTooth price:[NSString stringWithFormat:@"%.2f", self.amount] device:[device urlEncode] bankNo:@"" delegate:self];
    }
}

- (void)didWholeButtonClick:(id)sender
{
//    if (!self.isWholeSelect)
//    {
//        if (self.isBluetoothSelect)
//        {
//            self.isBluetoothSelect = NO;
//            [self.bluetoothButton setBackgroundImage:[UIImage imageNamed:@"pay_account_bluetooth_n"] forState:UIControlStateNormal];
//            [self.bluetoothButton setBackgroundImage:[UIImage imageNamed:@"pay_account_bluetooth_n"] forState:UIControlStateHighlighted];
//        }
//    }
    
    self.isBluetoothSelect = FALSE;
    
    if ([PosAccountManager getAudioUserName].length == 0 && [PosAccountManager getAudioPassword].length == 0)
    {
        [self.delegate didPadSettingWithType:kPadSettingViewPayAccount];
        return;
    }
    
//    self.isWholeSelect = !self.isWholeSelect;
//    if (self.isWholeSelect)
//    {
//        [self.wholeButton setBackgroundImage:[UIImage imageNamed:@"pay_account_whole_h"] forState:UIControlStateNormal];
//        [self.wholeButton setBackgroundImage:[UIImage imageNamed:@"pay_account_whole_h"] forState:UIControlStateHighlighted];
//        if (self.isBluetoothSelect)
//        {
//            self.isBluetoothSelect = NO;
//            [self.bluetoothButton setBackgroundImage:[UIImage imageNamed:@"pay_account_bluetooth_n"] forState:UIControlStateNormal];
//            [self.bluetoothButton setBackgroundImage:[UIImage imageNamed:@"pay_account_bluetooth_n"] forState:UIControlStateHighlighted];
//        }
//    }
//    else
//    {
//        [self.wholeButton setBackgroundImage:[UIImage imageNamed:@"pay_account_whole_n"] forState:UIControlStateNormal];
//        [self.wholeButton setBackgroundImage:[UIImage imageNamed:@"pay_account_whole_n"] forState:UIControlStateHighlighted];
//    }
    
    if ([PosAccountManager getAudioUserName].length != 0 && [PosAccountManager getAudioPassword].length != 0)
    {
        [[PayBankManager sharedManager] payWithAccountType:PayBankAccountType_Audio price:[NSString stringWithFormat:@"%.2f", self.amount] device:@"" bankNo:@"" delegate:self];
        [self removeFromSuperview];
    }
}


#pragma mark -
#pragma mark PayBankManagerDelegate Methods

- (void)pleaseSetUserName:(PayBankAccountType)type
{
    [self refresh];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadPayAccountSet)])
    {
        [self.delegate didPadSettingWithType:kPadSettingViewPayAccount];
    }
}

- (void)pleaseInstallVePos
{
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadCashRegisterSuccessWithPaymode:amount:bankNo:pos_type:)])
    {
        [self.delegate didPadCashRegisterSuccessWithPaymode:self.paymode amount:self.amount bankNo:@"" pos_type:@""];
    }
}

- (void)tradeSuccess:(NSString*)bankNo
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:LS(@"PadPaymentSuccess")
                                                       delegate:nil
                                              cancelButtonTitle:LS(@"IKnewButtonTitle")
                                              otherButtonTitles:nil, nil];
    [alertView show];
    
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadCashRegisterSuccessWithPaymode:amount:bankNo:pos_type:)])
    {
        NSString* posType = @"";
        if ( bankNo.length > 0 )
        {
            posType = self.isBluetoothSelect?@"bluetooth":@"audio";
        }
        [self.delegate didPadCashRegisterSuccessWithPaymode:self.paymode amount:self.amount bankNo:bankNo pos_type:posType];
    }
}

- (void)tradeFailed:(NSString *)errorMesage
{
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadCashRegisterFailed:)])
    {
        [self.delegate didPadCashRegisterFailed:errorMesage];
    }
}

@end
