//
//  PadOperateSuccessViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/11/25.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadOperateSuccessViewController.h"
#import "PadProjectConstant.h"
#import "UIImage+Resizable.h"
#import "BSFetchMemberDetailReqeustN.h"
#import "CBLoadingView.h"
#import "BSPrintPosOperateRequestNew.h"
#import "BSPrintPosOperateRequest.h"

#define kPadOperateSuccessButtonTag1        101
#define kPadOperateSuccessButtonTag2        102
#define kPadOperateSuccessButtonTag3        103
#define kPadOperateSuccessButtonTag4        104

@interface PadOperateSuccessViewController ()

@property (nonatomic, strong) NSString *detail;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) kPadOperateSuccessType type;

@end


@implementation PadOperateSuccessViewController

- (id)initWithOperateType:(kPadOperateSuccessType *)type detail:(NSString *)detail amount:(CGFloat)amount
{
    self = [self initWithNibName:@"PadOperateSuccessViewController" bundle:nil];
    if (self)
    {
        self.type = type;
        self.detail = detail;
        self.amount = amount;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(-150.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    CGFloat originY = 100.0;
    UIImage *successImage = [UIImage imageNamed:@"pad_success_mask"];
    UIImageView *successImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - successImage.size.width)/2.0, originY, successImage.size.width, successImage.size.height)];
    successImageView.backgroundColor = [UIColor clearColor];
    successImageView.image = successImage;
    [self.view addSubview:successImageView];
    originY += 100.0 + 36.0;
    
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(240.0, originY, self.view.frame.size.width - 2 * 240.0, 40.0)];
    successLabel.backgroundColor = [UIColor clearColor];
    successLabel.font = [UIFont systemFontOfSize:32.0];
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.textColor = COLOR(143.0, 160.0, 160.0, 1.0);
    if (self.type == kPadPosOperatePaymentSuccess)
    {
        successLabel.text = LS(@"PadPosOperatePaymentSuccess");
    }
    else if (self.type == kPadFreeCombinationCreateSuccess)
    {
        successLabel.text = LS(@"PadCreateSuccessTitle");
    }
    else if (self.type == kPadGiveGiftCardSuccess)
    {
        successLabel.text = LS(@"PadGiveGiftCardSuccessTitle");
    }
    [self.view addSubview:successLabel];
    originY += 40.0 + 12.0;
    
    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(240.0 + 32.0, originY, self.view.frame.size.width - 2 * 240.0 - 2 * 32.0, 20.0)];
    itemLabel.backgroundColor = [UIColor clearColor];
    itemLabel.font = [UIFont systemFontOfSize:16.0];
    itemLabel.textAlignment = NSTextAlignmentCenter;
    itemLabel.textColor = COLOR(143.0, 160.0, 160.0, 1.0);
    if (self.type == kPadPosOperatePaymentSuccess)
    {
        itemLabel.text = [NSString stringWithFormat:LS(@"PadCardInfoAmount"), self.amount];
    }
    else if (self.type == kPadFreeCombinationCreateSuccess)
    {
        itemLabel.text = [NSString stringWithFormat:LS(@"PadCreateItemName"), self.detail];
    }
    else if (self.type == kPadGiveGiftCardSuccess)
    {
        itemLabel.text = [NSString stringWithFormat:LS(@"PadGiveGiftCardValidityDate"), self.detail];
    }
    [self.view addSubview:itemLabel];
    originY += 20.0 + 8.0;
    
    if (self.type != kPadPosOperatePaymentSuccess && self.type != kPadGiveGiftCardSuccess)
    {
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(240.0 + 32.0, originY, self.view.frame.size.width - 2 * 240.0 - 2 * 32.0, 20.0)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.font = [UIFont systemFontOfSize:16.0];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.textColor = COLOR(143.0, 160.0, 160.0, 1.0);
        if (self.type == kPadFreeCombinationCreateSuccess)
        {
            priceLabel.text = [NSString stringWithFormat:LS(@"PadCreateItemPrice"), self.amount];
        }
        [self.view addSubview:priceLabel];
    }
    originY += 20.0 + 8.0;
    
    UIImage *contentImage = [UIImage imageNamed:@"pad_keyboard_background"];
    UIImageView *contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(240.0, 392.0, self.view.frame.size.width - 2 * 240.0, 268.0)];
    contentImageView.backgroundColor = [UIColor clearColor];
    contentImageView.image = [contentImage imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
    contentImageView.userInteractionEnabled = YES;
    [self.view addSubview:contentImageView];
    
    CGFloat buttonOrigin = 32.0;
    UIButton *operateButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    operateButton1.backgroundColor = [UIColor clearColor];
    operateButton1.frame = CGRectMake(32.0, buttonOrigin, contentImageView.frame.size.width - 2 * 32.0, 60.0);
    operateButton1.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [operateButton1 addTarget:self action:@selector(didOperateButotnClick:) forControlEvents:UIControlEventTouchUpInside];
    operateButton1.tag = kPadOperateSuccessButtonTag1;
    [contentImageView addSubview:operateButton1];
    buttonOrigin += 60.0 + 12.0;
    
    UIButton *operateButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    //if ( ![[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        operateButton2.backgroundColor = [UIColor clearColor];
        operateButton2.frame = CGRectMake(32.0, buttonOrigin, contentImageView.frame.size.width - 2 * 32.0, 60.0);
        operateButton2.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [operateButton2 addTarget:self action:@selector(didOperateButotnClick:) forControlEvents:UIControlEventTouchUpInside];
        operateButton2.tag = kPadOperateSuccessButtonTag2;
        [contentImageView addSubview:operateButton2];
        buttonOrigin += 60.0 + 12.0;
    }
    
    UIButton *operateButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    operateButton3.backgroundColor = [UIColor clearColor];
    operateButton3.frame = CGRectMake(32.0, buttonOrigin, contentImageView.frame.size.width - 2 * 32.0, 60.0);
    operateButton3.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [operateButton3 addTarget:self action:@selector(didOperateButotnClick:) forControlEvents:UIControlEventTouchUpInside];
    operateButton3.tag = kPadOperateSuccessButtonTag3;
    [contentImageView addSubview:operateButton3];
    buttonOrigin += 60.0 + 12.0;
    
    UIButton *operateButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    operateButton4.backgroundColor = [UIColor clearColor];
    operateButton4.frame = CGRectMake(32.0, buttonOrigin, contentImageView.frame.size.width - 2 * 32.0, 60.0);
    operateButton4.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [operateButton4 addTarget:self action:@selector(didOperateButotnClick:) forControlEvents:UIControlEventTouchUpInside];
    operateButton4.tag = kPadOperateSuccessButtonTag4;
    [contentImageView addSubview:operateButton4];
    buttonOrigin += 60.0 + 32.0;
    
    CGFloat contentHeight = 0.0;
    if (self.type == kPadFreeCombinationCreateSuccess)
    {
        operateButton2.hidden = YES;
        operateButton3.hidden = YES;
        operateButton4.hidden = YES;
        contentHeight = 32.0 * 2 + 60.0;
        [operateButton1 setTitle:LS(@"PadFinishButton") forState:UIControlStateNormal];
        [operateButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [operateButton1 setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
        [operateButton1 setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    }
    else
    {
//        if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
//        {
//            contentHeight = 32.0 * 2 + 60.0 * 2 + 12.0 * 2;
//        }
//        else
//        {
//            
//        }
        
        contentHeight = 32.0 * 2 + 60.0 * 4 + 12.0 * 4;
        
        [operateButton1 setTitle:LS(@"PadContinueCashier") forState:UIControlStateNormal];
        [operateButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [operateButton1 setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
        [operateButton1 setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
        
        if ( ![[PersonalProfile currentProfile].isYiMei boolValue] )
        {
            [operateButton2 setTitle:LS(@"PadAllotPerformance") forState:UIControlStateNormal];
        }
        else
        {
            [operateButton2 setTitle:LS(@"继续为该顾客收银") forState:UIControlStateNormal];
        }
        
        [operateButton2 setTitleColor:COLOR(96.0, 211.0, 212.0, 1.0) forState:UIControlStateNormal];
        [operateButton2 setBackgroundImage:[[UIImage imageNamed:@"pad_card_allot_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)] forState:UIControlStateNormal];
        [operateButton2 setBackgroundImage:[[UIImage imageNamed:@"pad_card_allot_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)] forState:UIControlStateHighlighted];
        
        [operateButton3 setTitle:LS(@"PadGiveGiftCard") forState:UIControlStateNormal];
        [operateButton3 setTitleColor:COLOR(96.0, 211.0, 212.0, 1.0) forState:UIControlStateNormal];
        [operateButton3 setBackgroundImage:[[UIImage imageNamed:@"pad_card_allot_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)] forState:UIControlStateNormal];
        [operateButton3 setBackgroundImage:[[UIImage imageNamed:@"pad_card_allot_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)] forState:UIControlStateHighlighted];
        
        [operateButton4 setTitle:@"打印收银小票" forState:UIControlStateNormal];
        [operateButton4 setTitleColor:COLOR(96.0, 211.0, 212.0, 1.0) forState:UIControlStateNormal];
        [operateButton4 setBackgroundImage:[[UIImage imageNamed:@"pad_card_allot_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)] forState:UIControlStateNormal];
        [operateButton4 setBackgroundImage:[[UIImage imageNamed:@"pad_card_allot_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)] forState:UIControlStateHighlighted];
    }
    contentImageView.frame = CGRectMake(contentImageView.frame.origin.x, (self.view.frame.size.height - originY - contentHeight)/3.0 + originY, contentImageView.frame.size.width, contentHeight);
}


#pragma mark -
#pragma mark Required Methods

- (void)didOperateButotnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    Boolean hide = true;
    if (button.tag == kPadOperateSuccessButtonTag1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSPadCashierSuccess object:self.operateID userInfo:nil];
    }
    else if (button.tag == kPadOperateSuccessButtonTag2)
    {
        if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
        {
//            if (self.card.member.memberID)
//            {
            if (self.card == nil)
            {
                CDMemberCard *memberCard = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.cardID forKey:@"cardID"];
                self.card = memberCard;
            }
            if (self.memberID == nil)
            {
                self.memberID = self.card.member.memberID;
            }
            NSLog(@"%@",self.card.member);
                BSFetchMemberDetailRequestN* request = [[BSFetchMemberDetailRequestN alloc] initWithMemberID:self.memberID];
                [[CBLoadingView shareLoadingView] show];
                [request execute];
                request.finished = ^(NSDictionary *params) {
                    [[CBLoadingView shareLoadingView] hide];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kBSCashMemberAgain object:self.card userInfo:nil];
                };
//            }
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSPadAllotPerformance object:self.operateID userInfo:nil];
        }
    }
    else if (button.tag == kPadOperateSuccessButtonTag3)
    {
        NSDictionary *userInfo = nil;
        if (self.member) {
            userInfo =  @{@"member":self.member};
        }
        if ([self.member.isDefaultCustomer integerValue] == 1) {
            hide = false;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSPadGiveGiftCard object:self.operateID userInfo:userInfo];
    }
    else if (button.tag == kPadOperateSuccessButtonTag4)
    {
        if ( [PersonalProfile currentProfile].printUrl.length > 2 )
        {
            BSPrintPosOperateRequestNew* request = [[BSPrintPosOperateRequestNew alloc] init];
            request.operateID = self.operateID;
            request.openCashBox = FALSE;
            request.isAfterPayment = TRUE;
            [request execute];
        }
        else
        {
            if ( ![[PersonalProfile currentProfile].isYiMei boolValue] )
            {
                [[BSPrintPosOperateRequest alloc] printWithPosOperateID:self.operateID];
            }
            else
            {
                BSPrintPosOperateRequestNew* request = [[BSPrintPosOperateRequestNew alloc] init];
                request.operateID = self.operateID;
                request.openCashBox = FALSE;
                request.isAfterPayment = TRUE;
                [request execute];
            }
        }
        
        hide = false;
    }
    
    if (hide) {
        [self performSelector:@selector(delayToHide) withObject:nil afterDelay:1];
    }
}

- (void)delayToHide
{
    [self.maskView hidden];
}

@end
