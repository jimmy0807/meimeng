//
//  ScanQRCodeView.h
//  Mata
//
//  Created by lining on 16/7/11.
//  Copyright © 2016年 Mata. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHorizontalMargin   62
#define kVerticalMargin     20

#define kRectangleWidth (IC_SCREEN_WIDTH - 2*kMargin)
#define kRectangleHeight kRectangleWidth

@protocol ScanQRCodeViewDelegate <NSObject>

@optional
- (void)didFinishScanWithResult:(NSString *)result;

@end

@interface ScanQRCodeView : UIView
- (instancetype) initWithFrame:(CGRect)frame delegate:(id<ScanQRCodeViewDelegate>)delegate;

- (BOOL) canAccessDevice;

- (void)startScan;
- (void)stopScan;
@end
