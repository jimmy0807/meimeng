//
//  QRCodeView.h
//  CardBag
//
//  Created by jimmy on 13-9-4.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScanAreaSize        (DEVICE_IS_IPAD ? 320.0 : 216.0)
#define ScanAreaOriginX     (IC_SCREEN_WIDTH - ScanAreaSize)/2.0
#define ScanAreaOriginY     ((IC_SCREEN_HEIGHT - ScanAreaSize)/2.0 - 44.0)
#define ScanLeftRightMargin 20.0

@class QRCodeView;
@protocol QRCodeViewDelegate <NSObject>
- (void)didQRBackButtonClick:(QRCodeView *)qrCodeView;
@end

@interface QRCodeView : UIView

@property (nonatomic, assign) CGRect scanRect;


- (id)initWithDelegate:(id<QRCodeViewDelegate>)delegate;

- (void)startScanTimer;
- (void)stopScanTimer;

@end
