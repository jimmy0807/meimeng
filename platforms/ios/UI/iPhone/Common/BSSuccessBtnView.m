//
//  BSSuccessBtnView.m
//  Boss
//
//  Created by lining on 16/9/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSSuccessBtnView.h"
#import "QRCodeGenerator.h"

@implementation BSSuccessBtnView

+ (instancetype)createViewWithTopTip:(NSString *)topTip contentTitle:(NSString *)title detailTitle:(NSString *)detailTitle
{
    BSSuccessBtnView *successView =  [self loadFromNib];
    successView.contentView.hidden = false;
    successView.QRCodeView.hidden = true;
    
    successView.topTipLabel.text = topTip;
    if (topTip.length == 0) {
        successView.topTipView.hidden = true;
    }
    
    successView.contentLabel.text = title;
    successView.contentDetailLabel.text = detailTitle;
    
    return successView;
}

+ (instancetype)createQRViewWithUrl:(NSString *)url
{
    BSSuccessBtnView *successView =  [self loadFromNib];
    successView.contentView.hidden = true;
    successView.QRCodeView.hidden = false;
    successView.QRImgView.image = [QRCodeGenerator qrImageForString:url imageSize:175];
//    successView.topTipLabel.text = @"微信扫一扫";
    successView.topTipView.hidden = true;
    return successView;
}



#pragma mark - btn action
- (IBAction)cashierBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didCashierBtnPressed)]) {
        [self.delegate didCashierBtnPressed];
    }
    
}

- (IBAction)assignBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didAssignBtnPressed)]) {
        [self.delegate didAssignBtnPressed];
    }
}

- (IBAction)sendBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSendBtnPressed)]) {
        [self.delegate didSendBtnPressed];
    }
}

- (IBAction)backBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didBackBtnPressed)]) {
        [self.delegate didBackBtnPressed];
    }
}

@end
