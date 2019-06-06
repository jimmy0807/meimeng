//
//  BNScanCodeViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/8/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BNScanCodeViewController.h"
#import "CBWebViewController.h"

@interface BNScanCodeViewController ()

@property (nonatomic, strong) QRCodeView *overlayView;
@property (nonatomic, assign) id<BNScanCodeDelegate> delegate;

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@end

@implementation BNScanCodeViewController

- (id)initWithDelegate:(id<BNScanCodeDelegate>)delegate
{
    self = [super initWithNibName:@"BNScanCodeViewController" bundle:nil];
    if (self)
    {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    self.navigationController.navigationBarHidden = YES;
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.session = [[AVCaptureSession alloc] init];
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            [self deviceCameraAuthorizationStatus:granted];
        }];
    }
    else if (status == AVAuthorizationStatusAuthorized)
    {
        [self deviceCameraAuthorizationStatus:YES];
    }
    else
    {
        [self deviceCameraAuthorizationStatus:NO];
    }
    self.output.rectOfInterest = CGRectMake(ScanAreaOriginY/IC_SCREEN_HEIGHT, ScanAreaOriginX/IC_SCREEN_WIDTH, ScanAreaSize/IC_SCREEN_HEIGHT, ScanAreaSize/IC_SCREEN_WIDTH);
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.view.layer.bounds;
    self.preview.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
    [self.view.layer insertSublayer:self.preview atIndex:0];
    [self.session startRunning];
    
    self.overlayView = [[QRCodeView alloc] initWithDelegate:self];
    [self.view addSubview:self.overlayView];
    [self.overlayView startScanTimer];
}

- (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation {
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationPortrait: {
            return AVCaptureVideoOrientationPortrait;
        }
        case UIInterfaceOrientationLandscapeLeft: {
            return AVCaptureVideoOrientationLandscapeLeft;
        }
        case UIInterfaceOrientationLandscapeRight: {
            return AVCaptureVideoOrientationLandscapeRight;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            return AVCaptureVideoOrientationPortraitUpsideDown;
        }
        default:
            break;
    }
    
    return AVCaptureVideoOrientationPortrait;
}

- (void)deviceCameraAuthorizationStatus:(BOOL)status
{
    if (status)
    {
        if ([self.session canAddInput:self.input] && [self.session canAddOutput:self.output])
        {
            [self.session addInput:self.input];
            [self.session addOutput:self.output];
        }
        
        if ([self.session canAddInput:self.input])
        {
            [self.session addInput:self.input];
        }
        if ([self.session canAddOutput:self.output])
        {
            [self.session addOutput:self.output];
        }
        
        if (IS_SDK8)
        {
            self.output.metadataObjectTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode];
        }
        else if (IS_SDK7)
        {
            self.output.metadataObjectTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
        }
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



#pragma mark -
#pragma mark QRCodeViewDelegate Methods

- (void)didQRBackButtonClick:(QRCodeView *)qrCodeView
{
    self.navigationController.navigationBarHidden = NO;
    if ( [self.delegate respondsToSelector:@selector(didScanCodeViewControllerBack)] )
    {
        [self.delegate didScanCodeViewControllerBack];
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark -
#pragma mark AVCaptureMetadataOutputObjectsDelegate Methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        NSString *result = metadataObject.stringValue;
        if (result.length == 0)
        {
            return;
        }
        
        [self.session stopRunning];
        [self.overlayView stopScanTimer];
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popViewControllerAnimated:NO];
        if (self.delegate && [self.delegate respondsToSelector:@selector(scanCodeViewController:didScanSuccess:)])
        {
            [self.delegate scanCodeViewController:self didScanSuccess:metadataObject.stringValue];
        }
    }
}

@end
