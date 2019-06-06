//
//  BNCameraView.m
//  meim
//
//  Created by jimmy on 2017/9/17.
//
//

#import "BNCameraView.h"
#import <AVFoundation/AVFoundation.h>

@interface BNCameraView ()<AVCaptureMetadataOutputObjectsDelegate>
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;
//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;
//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;
//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;
//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic)UIButton *PhotoButton;
@property (nonatomic)UIImageView *imageView;
@property (nonatomic)UIView *focusView;
@property (nonatomic, copy)takePhotoBlock photoblock;
@property (nonatomic, strong)UIView* preViewView;
@property (nonatomic, strong)UIImageView* preViewImageView;
@end

@implementation BNCameraView

+(BNCameraView*)showinView:(UIView*)v takPhoto:(takePhotoBlock)block
{
    BNCameraView* cameraView = [[BNCameraView alloc] initWithFrame:v.bounds];
    [cameraView customCamera];
    [cameraView customUI];
    [cameraView customPreview];
    [v addSubview:cameraView];
    
    cameraView.photoblock = block;
    
    return cameraView;
}

- (void)customUI
{
    _PhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _PhotoButton.frame = CGRectMake(self.frame.size.width-100, self.frame.size.height/2-35, 70, 70);
    [_PhotoButton setImage:[UIImage imageNamed:@"photograph"] forState: UIControlStateNormal];
    [_PhotoButton setImage:[UIImage imageNamed:@"photograph_Select"] forState:UIControlStateNormal];
    [_PhotoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_PhotoButton];
    
    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _focusView.layer.borderWidth = 1.0;
    _focusView.layer.borderColor =[UIColor greenColor].CGColor;
    _focusView.backgroundColor = [UIColor clearColor];
    [self addSubview:_focusView];
    _focusView.hidden = YES;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(self.frame.size.width-100, self.frame.size.height*1/4.0 + 46, 66, 28);
    leftButton.layer.cornerRadius = 14;
    leftButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [leftButton setTitleColor:COLOR(246, 197, 1, 1) forState:UIControlStateNormal];
    [leftButton setTitle:@"完成" forState:UIControlStateNormal];
    leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [leftButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)customCamera
{
    [self registerNofitificationForMainThread:@"ManuallyFocus"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusAtCenter)
                                                 name:@"DeviceMoved" object:nil];
    self.backgroundColor = [UIColor whiteColor];
    
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
        
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
    [self.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
    CGPoint point = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self focusAtPoint:point];
    //[self rotateLayer];
}

- (void)customPreview
{
    self.preViewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.preViewView.backgroundColor = [UIColor  blackColor];
    [self addSubview:self.preViewView];
    self.preViewView.hidden = TRUE;
    
    self.preViewImageView = [[UIImageView alloc] initWithFrame:self.preViewView.bounds];
    [self.preViewView addSubview:self.preViewImageView];
    
    UIView* blackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 60, self.frame.size.width, 60)];
    blackView.backgroundColor = [UIColor  clearColor];
//    blackView.alpha = 0.3;
    [self.preViewView addSubview:blackView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(self.frame.size.width - 100, self.frame.size.height*1/4.0 + 46, 66, 28);
    leftButton.layer.cornerRadius = 14;
    leftButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [leftButton setTitleColor:COLOR(246, 197, 1, 1) forState:UIControlStateNormal];
    [leftButton setTitle:@"重拍" forState:UIControlStateNormal];
    leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [leftButton addTarget:self action:@selector(photoAgainButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.preViewView addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(self.frame.size.width - 100, self.frame.size.height*3/4.0 - 106, 66, 28);
    rightButton.layer.cornerRadius = 14;
    rightButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    rightButton.titleLabel.textColor = COLOR(246, 197, 1, 1);
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:COLOR(246, 197, 1, 1) forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.preViewView addSubview:rightButton];
}

- (void)photoAgainButtonPressed:(id)sender
{
    self.preViewView.hidden = TRUE;
}

- (void)confirmButtonPressed:(id)sender
{
    self.photoblock(self.preViewImageView.image);
    self.preViewView.hidden = TRUE;
}

- (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation {
    switch ([[UIDevice currentDevice]orientation]) {
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
            return AVCaptureVideoOrientationLandscapeRight;
    }
    
    return AVCaptureVideoOrientationLandscapeRight;
}

-(void)focusAtCenter
{
    CGPoint point = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self focusAtPoint:point];
}

-(void)rotateLayer{
    CALayer * stuckview = self.previewLayer;
    CGRect layerRect = [[self layer] bounds];
    
    UIDeviceOrientation orientation =[[UIDevice currentDevice]orientation];
    
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            stuckview.affineTransform = CGAffineTransformMakeRotation(M_PI+ M_PI_2); // 270 degress
            
            break;
        case UIDeviceOrientationLandscapeRight:
            stuckview.affineTransform = CGAffineTransformMakeRotation(M_PI_2); // 90 degrees
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            stuckview.affineTransform = CGAffineTransformMakeRotation(M_PI); // 180 degrees
            break;
        default:
            stuckview.affineTransform = CGAffineTransformMakeRotation(0.0);
            [stuckview setBounds:layerRect];
            break;
    }
    [stuckview setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
}

- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManuallyFocus" object:nil];
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}
- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
    
}

- (void) shutterCamera
{
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    videoConnection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage* image = [UIImage imageWithData:imageData];
        //self.photoblock(image);
        //[self.session stopRunning];
        self.preViewView.hidden = FALSE;
        self.preViewImageView.image = image;
#if 0
        [self saveImageToPhotoAlbum:self.image];
        self.imageView = [[UIImageView alloc]initWithFrame:self.previewLayer.frame];
        [self.view insertSubview:_imageView belowSubview:_PhotoButton];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.image = _image;
        NSLog(@"image size = %@",NSStringFromCGSize(self.image.size));
#endif
    }];
}

-(void)cancle
{
    [self removeFromSuperview];
}


@end
