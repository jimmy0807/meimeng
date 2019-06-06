
//
//  ScanQRCodeView.m
//  Mata
//
//  Created by lining on 16/7/11.
//  Copyright © 2016年 Mata. All rights reserved.
//

#import "ScanQRCodeView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Resizable.h"
#import "UIView+Frame.h"

@interface ScanQRCodeView ()<AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic, weak) id<ScanQRCodeViewDelegate>delegate;
@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureDeviceInput  *input;
@property(nonatomic, strong) AVCaptureMetadataOutput *output;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer * scanView;


@property (nonatomic, strong) UIImageView * overLayView;

@property (nonatomic, assign) CGRect scanRect;

@property (nonatomic, strong) UIImageView *moveLine;
@property (nonatomic, assign) BOOL isScaning;

@property (nonatomic, assign) BOOL line_down;

@end


@implementation ScanQRCodeView

- (instancetype)initWithFrame:(CGRect) frame delegate:(id<ScanQRCodeViewDelegate>)delegate
{
    self = [self initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
//    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        if ([self canAccessDevice]) {
            [self.layer addSublayer:self.scanView];
            
            [self addSubview:self.overLayView];
            [self addSubview:self.moveLine];

           
            [self startScan];
            
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:LS(@"QRAllowAccessCamera") delegate:nil
                                                      cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    return self;
}

- (BOOL) canAccessDevice
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized)
    {
        return true;
    }

    return false;
}


/**
 *  扫描视图
 */
- (AVCaptureVideoPreviewLayer *)scanView
{
    if (!_scanView) {
        _scanView = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
        _scanView.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _scanView.frame = self.bounds;
    }
    return _scanView;
}


- (AVCaptureSession *)session
{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];//高质量采集
        if ([self.session canAddInput: self.input]) {
            [_session addInput: _input];
        }
        if ([self.session canAddOutput: self.output]) {
            [_session addOutput: _output];
        }
        
        //需先将output和session关联起来
        if (IS_SDK8)
        {
            _output.metadataObjectTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode];
        }
        else if (IS_SDK7)
        {
            _output.metadataObjectTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
        }

    }
    return _session;
}

- (AVCaptureMetadataOutput *)output
{
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate: self queue: dispatch_get_main_queue()];
//        _output.rectOfInterest =
        
//        CGFloat minY = (IC_SCREEN_HEIGHT - kRectangleHeight) * 0.5 / IC_SCREEN_HEIGHT;
//        CGFloat maxY = kRectangleHeight / IC_SCREEN_HEIGHT;
//        
//        CGFloat minX = kMargin / IC_SCREEN_WIDTH;
//        CGFloat maxX = kRectangleWidth / IC_SCREEN_WIDTH;
//        _output.rectOfInterest = CGRectMake(minY,minX,maxY,maxX);
    }
    return _output;
}


- (AVCaptureDeviceInput *)input
{
    if (!_input) {
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
        _input = [AVCaptureDeviceInput deviceInputWithDevice: device error: nil];
    }
    return _input;
}



- (UIImageView *)overLayView
{
    if (!_overLayView) {
        _overLayView = [[UIImageView alloc] initWithFrame:CGRectMake(kHorizontalMargin, kVerticalMargin, IC_SCREEN_WIDTH - 2*kHorizontalMargin, 150 - 2 * kVerticalMargin)];
        
        UIImage *rectImg = [UIImage imageNamed:@"scan_over_rect.png"];
        _overLayView.image = [rectImg resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 50, 50)];
        
    }
    return _overLayView;
}

-(UIImageView *)moveLine
{
    if (!_moveLine) {
        
        CGFloat minY = kVerticalMargin;
        
        UIImage *lineImg = [UIImage imageNamed:@"scan_line.png"];
        
        _moveLine = [[UIImageView alloc] initWithFrame:CGRectMake(kHorizontalMargin, minY, IC_SCREEN_WIDTH - 2*kHorizontalMargin, 2)];
        _moveLine.image = lineImg;
    }
    return _moveLine;
}

#pragma mark - star & stop scan
- (void)startScan
{
    if (!self.isScaning) {
        [self.session startRunning];
        [self startMoveLineAnimation];
        self.isScaning = true;
    }
}

- (void)stopScan
{
    if (self.isScaning) {
        [self.session stopRunning];
        self.isScaning = false;
    }
 
}


#pragma mark - line move animation
- (void)startMoveLineAnimation
{
    CGFloat minY = kVerticalMargin;
    CGFloat maxY = self.height - kVerticalMargin - 2;

    //method 1
    [UIView animateWithDuration:1 animations:^{
        
        CGRect frame = self.moveLine.frame;
        if (frame.origin.y == minY) {
            frame.origin.y = maxY;
        }
        else
        {
            frame.origin.y = minY;
        }
        self.moveLine.frame = frame;
    }completion:^(BOOL finished) {
        NSLog(@"finished: %d",finished);
        if (self.isScaning) {
            [self startMoveLineAnimation];
        }
    }];

}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
/**
 *  二维码扫描数据返回
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    if (metadataObjects.count > 0) {
        [self stopScan];

        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        NSString *result = metadataObject.stringValue;
       
        NSLog(@"扫描返回数据: %@",result);
        [self performSelector:@selector(startScan) withObject:nil afterDelay:1.75];
        
        if ([self.delegate respondsToSelector:@selector(didFinishScanWithResult:)]) {
            [self.delegate didFinishScanWithResult:result];
        }
    }
    else
    {
        NSLog(@"扫描无返回结果");
    }
}


- (void)dealloc
{
    [self stopScan];
}

@end
