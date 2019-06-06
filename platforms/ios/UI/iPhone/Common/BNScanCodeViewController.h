//
//  BNScanCodeViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/8/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "QRCodeView.h"
#import <AVFoundation/AVFoundation.h>

@class BNScanCodeViewController;
@protocol BNScanCodeDelegate <NSObject>
- (void)scanCodeViewController:(BNScanCodeViewController *)viewController didScanSuccess:(NSString *)result;
@optional
- (void)didScanCodeViewControllerBack;
@end

@interface BNScanCodeViewController : ICCommonViewController <AVCaptureMetadataOutputObjectsDelegate, QRCodeViewDelegate>

- (id)initWithDelegate:(id<BNScanCodeDelegate>)delegate;

@property(nonatomic, strong)CDPOSPayMode* paymode;

@end
