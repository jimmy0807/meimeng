//
//  QRCodeView.m
//  CardBag
//
//  Created by jimmy on 13-9-4.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import "QRCodeView.h"
#import "UIImage+Resizable.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeView()

@property (nonatomic, strong) NSTimer *scanTimer;
@property (nonatomic, assign) id<QRCodeViewDelegate> delegate;

@property (nonatomic, assign) BOOL isTorchModeOn;
@property (nonatomic, assign) CGFloat scanSpeed;
@property (nonatomic, strong) UIImageView *scanImageView;

@end

@implementation QRCodeView

- (id)initWithDelegate:(id<QRCodeViewDelegate>)delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT)];
    if (self)
    {
        self.delegate = delegate;
        self.backgroundColor = [UIColor clearColor];
        self.scanRect = CGRectMake(ScanAreaOriginX, ScanAreaOriginY, ScanAreaSize, ScanAreaSize);
        
        UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScanAreaOriginX + ScanAreaSize, ScanAreaOriginY)];
        maskImageView.backgroundColor = [UIColor blackColor];
        maskImageView.alpha = 0.4;
        [self addSubview:maskImageView];
        
        maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, ScanAreaOriginY, ScanAreaOriginX, IC_SCREEN_HEIGHT - ScanAreaOriginY)];
        maskImageView.backgroundColor = [UIColor blackColor];
        maskImageView.alpha = 0.4;
        [self addSubview:maskImageView];
        
        maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScanAreaOriginX, ScanAreaOriginY + ScanAreaSize, IC_SCREEN_WIDTH - ScanAreaOriginX, IC_SCREEN_HEIGHT - ScanAreaOriginY - ScanAreaSize)];
        maskImageView.backgroundColor = [UIColor blackColor];
        maskImageView.alpha = 0.4;
        [self addSubview:maskImageView];
        
        maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScanAreaOriginX + ScanAreaSize, 0.0, ScanAreaOriginX, ScanAreaOriginY + ScanAreaSize)];
        maskImageView.backgroundColor = [UIColor blackColor];
        maskImageView.alpha = 0.4;
        [self addSubview:maskImageView];
        
        UIImage *cornerImage = [UIImage imageNamed:@"qr_scan_corner_1"];
        UIImageView *cornerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScanAreaOriginX, ScanAreaOriginY, cornerImage.size.width, cornerImage.size.height)];
        cornerImageView.backgroundColor = [UIColor clearColor];
        cornerImageView.image = cornerImage;
        [self addSubview:cornerImageView];
        
        cornerImage = [UIImage imageNamed:@"qr_scan_corner_2"];
        cornerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScanAreaOriginX + ScanAreaSize - cornerImage.size.width, ScanAreaOriginY, cornerImage.size.width, cornerImage.size.height)];
        cornerImageView.backgroundColor = [UIColor clearColor];
        cornerImageView.image = cornerImage;
        [self addSubview:cornerImageView];
        
        cornerImage = [UIImage imageNamed:@"qr_scan_corner_3"];
        cornerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScanAreaOriginX, ScanAreaOriginY + ScanAreaSize - cornerImage.size.height, cornerImage.size.width, cornerImage.size.height)];
        cornerImageView.backgroundColor = [UIColor clearColor];
        cornerImageView.image = cornerImage;
        [self addSubview:cornerImageView];
        
        cornerImage = [UIImage imageNamed:@"qr_scan_corner_4"];
        cornerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScanAreaOriginX + ScanAreaSize - cornerImage.size.width, ScanAreaOriginY + ScanAreaSize - cornerImage.size.height, cornerImage.size.width, cornerImage.size.height)];
        cornerImageView.backgroundColor = [UIColor clearColor];
        cornerImageView.image = cornerImage;
        [self addSubview:cornerImageView];
        
        UIImage *backImage = [UIImage imageNamed:DEVICE_IS_IPAD ? @"qr_back_ipad_n" : @"qr_back_n"];
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, backImage.size.width + 2 * ScanLeftRightMargin, backImage.size.height + 2 * ScanLeftRightMargin)];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(ScanLeftRightMargin, ScanLeftRightMargin, ScanLeftRightMargin, ScanLeftRightMargin)];
        [backButton setImage:backImage forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:DEVICE_IS_IPAD ? @"qr_back_ipad_h" : @"qr_back_h"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        UIImage *flashImage = [UIImage imageNamed:DEVICE_IS_IPAD ? @"qr_flash_ipad_n" : @"qr_flash_n"];
        UIButton *flashButton = [[UIButton alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - ScanLeftRightMargin - flashImage.size.width - ScanLeftRightMargin, (backImage.size.height - flashImage.size.height)/2.0, flashImage.size.width + 2 * ScanLeftRightMargin, flashImage.size.height + 2 * ScanLeftRightMargin)];
        [flashButton setImageEdgeInsets:UIEdgeInsetsMake(ScanLeftRightMargin, ScanLeftRightMargin, ScanLeftRightMargin, ScanLeftRightMargin)];
        [flashButton setImage:flashImage forState:UIControlStateNormal];
        [flashButton setImage:[UIImage imageNamed:DEVICE_IS_IPAD ? @"qr_flash_ipad_h" : @"qr_flash_h"] forState:UIControlStateHighlighted];
        [flashButton addTarget:self action:@selector(didFlashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:flashButton];
        
        UIView *scanView = [[UIView alloc] initWithFrame:CGRectMake(ScanAreaOriginX, ScanAreaOriginY, ScanAreaSize, ScanAreaSize)];
        scanView.clipsToBounds = YES;
        [self addSubview:scanView];
        UIImage *scanImage = [UIImage imageNamed:DEVICE_IS_IPAD ? @"qr_scan_ipad" : @"qr_scan"];
        self.scanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, ScanAreaSize, ScanAreaSize, ScanAreaSize)];
        self.scanImageView.image = scanImage;
        [scanView addSubview:self.scanImageView];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScanLeftRightMargin, ScanAreaOriginY + ScanAreaSize + 44.0, IC_SCREEN_WIDTH - 2 * ScanLeftRightMargin, 20.0)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textColor = [UIColor whiteColor];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.font = [UIFont boldSystemFontOfSize:DEVICE_IS_IPAD ? 24.0 : 17.0];
        detailLabel.text = LS(@"QRScanInfomation");
        [self addSubview:detailLabel];
    }
    
    return self;
}

#pragma mark -
#pragma mark Requried Methods

- (void)didBackButtonClick:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    if ([self.delegate respondsToSelector:@selector(didQRBackButtonClick:)])
    {
        [self.delegate didQRBackButtonClick:self];
    }
}

- (void)didFlashButtonClick:(id)sender
{
    UIButton *flashButton = (UIButton *)sender;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        [device lockForConfiguration:nil];
        if (self.isTorchModeOn)
        {
            self.isTorchModeOn = NO;
            [device setTorchMode:AVCaptureTorchModeOff];
            [flashButton setImage:[UIImage imageNamed:DEVICE_IS_IPAD ? @"qr_flash_ipad_n" : @"qr_flash_n"] forState:UIControlStateNormal];
            [flashButton setImage:[UIImage imageNamed:DEVICE_IS_IPAD ? @"qr_flash_ipad_h" : @"qr_flash_h"] forState:UIControlStateHighlighted];
        }
        else
        {
            self.isTorchModeOn = YES;
            [device setTorchMode:AVCaptureTorchModeOn];
            [flashButton setImage:[UIImage imageNamed:DEVICE_IS_IPAD ? @"qr_flash_ipad_h" : @"qr_flash_h"] forState:UIControlStateNormal];
            [flashButton setImage:[UIImage imageNamed:DEVICE_IS_IPAD ? @"qr_flash_ipad_n" : @"qr_flash_n"] forState:UIControlStateHighlighted];
        }
        [device unlockForConfiguration];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"DeviceHasNoTorch")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}


#pragma mark -
#pragma mark Requried Methods

- (void)startScanTimer
{
    if (self.scanTimer != nil)
    {
        [self.scanTimer invalidate];
        self.scanTimer = nil;
    }
    
    self.scanSpeed = 0.0;
    self.scanImageView.frame = CGRectMake(0.0, -self.scanImageView.frame.size.height, self.scanImageView.frame.size.width, self.scanImageView.frame.size.height);
    
    self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(doScanAction) userInfo:nil repeats:YES];
    [self.scanTimer fire];
}

- (void)stopScanTimer
{
    if (self.scanTimer != nil)
    {
        [self.scanTimer invalidate];
        self.scanTimer = nil;
    }
    
    self.scanSpeed = 0.0;
    self.scanImageView.frame = CGRectMake(0.0, -self.scanImageView.frame.size.height, self.scanImageView.frame.size.width, self.scanImageView.frame.size.height);
}

- (void)doScanAction
{
    if (self.scanImageView.frame.origin.y < ScanAreaSize + self.scanImageView.frame.size.height + 20.0)
    {
        CGFloat originY = self.scanImageView.frame.origin.y;
        self.scanSpeed += 0.0012;
        originY += self.scanSpeed;
        self.scanImageView.frame = CGRectMake(self.scanImageView.frame.origin.x, originY, self.scanImageView.frame.size.width, self.scanImageView.frame.size.height);
    }
    else
    {
        [self performSelector:@selector(startScanTimer) withObject:nil afterDelay:0.5];
    }
}

@end
