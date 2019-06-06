//
//  BSCameraPickerController.m
//  Camera
//
//  Created by XiaXianBing on 15/7/10.
//  Copyright (c) 2015年 XiaXianBing. All rights reserved.
//


#import "BSCameraPickerController.h"
#import "UIImage+Orientation.h"

#define kAngleMargin        27.5
#define kBSCameraPickerMaskViewTag  9999

@interface BSCameraPickerController ()

@property (nonatomic, strong) UIView *bsOverlayView;
@property (nonatomic, assign) id<BSCameraPickerControllerDelegate> bsdelegate;

@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) CGFloat overlayViewWidth;
@property (nonatomic, assign) CGFloat overlayViewHeight;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) UIDeviceOrientation deviceOrientation;

@end

@implementation BSCameraPickerController

- (id)initWithBSDelegate:(id<BSCameraPickerControllerDelegate>)bsdelegate
{
    self = [super init];
    if (self != nil)
    {
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.delegate = self;
        self.allowsEditing = NO;
        [self.navigationBar setTintColor:[UIColor clearColor]];
        
        [self initBSOverlayView];
        self.deviceOrientation = [UIDevice currentDevice].orientation;
        [self refreshBSOverlayView];
        self.cameraOverlayView = self.bsOverlayView;
        self.bsdelegate = bsdelegate;
        
        self.motionManager = [[CMMotionManager alloc] init];
        if (!self.motionManager.accelerometerActive)
        {
            // 检查传感器在设备上是否可用
        }
        self.motionManager.accelerometerUpdateInterval = 0.01;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        
        UIDeviceOrientation orientation = [self checkOrientation:accelerometerData];
        if (orientation == UIDeviceOrientationUnknown)
        {
            return ;
        }
        
        if (orientation != self.deviceOrientation)
        {
            self.deviceOrientation = orientation;
            [self refreshBSOverlayView];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.motionManager stopAccelerometerUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 
- (BOOL)shouldAutorotate
{
    return true;
}

- (void)dealloc
{
    ;
}


#pragma mark -
#pragma mark Required Methods

- (UIDeviceOrientation)checkOrientation:(CMAccelerometerData *)accelerometerData
{
    CGFloat accelerationX = accelerometerData.acceleration.x;
    CGFloat accelerationY = accelerometerData.acceleration.y;
    CGFloat angle = (atan2(accelerationY, accelerationX)) * 180/M_PI;
    if (angle >= (-90.0 - kAngleMargin) && angle <= (-90.0 + kAngleMargin))
    {
        return UIDeviceOrientationPortrait;
    }
    else if (angle >= (90.0 - kAngleMargin + 7.5) && angle <= (90.0 + kAngleMargin - 7.5))
    {
        return UIDeviceOrientationPortraitUpsideDown;
    }
    else if (angle <= (-180.0 + kAngleMargin) || angle >= (180.0 - kAngleMargin))
    {
        return UIDeviceOrientationLandscapeLeft;
    }
    else if (angle >= -kAngleMargin && angle <= kAngleMargin)
    {
        return UIDeviceOrientationLandscapeRight;
    }
    
    return UIDeviceOrientationUnknown;
}

- (void)initBSOverlayView
{
    self.bsOverlayView = [[UIView alloc] init];
    self.bsOverlayView.backgroundColor = [UIColor clearColor];
    
    UIView *topOverlayView = [[UIView alloc] init];
    topOverlayView.backgroundColor = [UIColor blackColor];
    topOverlayView.alpha = 0.3;
    topOverlayView.userInteractionEnabled = NO;
    topOverlayView.tag = 101;
    topOverlayView.hidden = YES;
    [self.bsOverlayView addSubview:topOverlayView];
    
    UIView *topShadowView = [[UIView alloc] init];
    topShadowView.backgroundColor = [UIColor whiteColor];
    topShadowView.alpha = 0.5;
    topShadowView.tag = 102;
    topShadowView.hidden = YES;
    [self.bsOverlayView addSubview:topShadowView];
    
    UIView *leftOverlayView = [[UIView alloc] init];
    leftOverlayView.backgroundColor = [UIColor blackColor];
    leftOverlayView.alpha = 0.3;
    leftOverlayView.userInteractionEnabled = NO;
    leftOverlayView.tag = 201;
    leftOverlayView.hidden = YES;
    [self.bsOverlayView addSubview:leftOverlayView];
    
    UIView *leftShadowView = [[UIView alloc] init];
    leftShadowView.backgroundColor = [UIColor whiteColor];
    leftShadowView.alpha = 0.5;
    leftShadowView.tag = 202;
    leftShadowView.hidden = YES;
    [self.bsOverlayView addSubview:leftShadowView];
    
    UIView *rightShadowView = [[UIView alloc] init];
    rightShadowView.backgroundColor = [UIColor whiteColor];
    rightShadowView.alpha = 0.5;
    rightShadowView.tag = 301;
    rightShadowView.hidden = YES;
    [self.bsOverlayView addSubview:rightShadowView];
    
    UIView *rightOverlayView = [[UIView alloc] init];
    rightOverlayView.backgroundColor = [UIColor blackColor];
    rightOverlayView.alpha = 0.3;
    rightOverlayView.userInteractionEnabled = NO;
    rightOverlayView.tag = 302;
    rightOverlayView.hidden = YES;
    [self.bsOverlayView addSubview:rightOverlayView];
    
    UIView *bottomShadowView = [[UIView alloc] init];
    bottomShadowView.backgroundColor = [UIColor whiteColor];
    bottomShadowView.alpha = 0.5;
    bottomShadowView.tag = 401;
    bottomShadowView.hidden = YES;
    [self.bsOverlayView addSubview:bottomShadowView];
    
    UIView *bottomOverlayView = [[UIView alloc] init];
    bottomOverlayView.backgroundColor = [UIColor blackColor];
    bottomOverlayView.alpha = 0.3;
    bottomOverlayView.tag = 402;
    bottomOverlayView.hidden = YES;
    [self.bsOverlayView addSubview:bottomOverlayView];
}

- (void)refreshBSOverlayView
{
    self.topMargin = 0.0;
    self.rightMargin = 0.0;
    self.bottomMargin = 0.0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        if (IC_SCREEN_HEIGHT == 480.0)
        {
            self.topMargin = 0.0;
            self.bottomMargin = 53.0;
        }
        else if (IC_SCREEN_HEIGHT == 568.0)
        {
            self.topMargin = 40.0;
            self.bottomMargin = 101.5;
        }
        else if (IC_SCREEN_HEIGHT == 1024.0)
        {
            self.rightMargin = 101.5;
        }
    }
    else
    {
        if (IC_SCREEN_WIDTH == 320.0)
        {
            if (IC_SCREEN_HEIGHT == 480.0)
            {
                self.topMargin = 40.0;
                self.bottomMargin = 73.0;
            }
            else if (IC_SCREEN_HEIGHT == 568.0)
            {
                self.topMargin = 40.0;
                self.bottomMargin = 101.5;
            }
        }
        else if (IC_SCREEN_WIDTH == 375.0)
        {
            self.topMargin = 44.0;
            self.bottomMargin = 123.0;
        }
        else if (IC_SCREEN_WIDTH == 414.0)
        {
            self.topMargin = 66.0;
            self.bottomMargin = 210.0;
        }
        else if (IC_SCREEN_WIDTH == 768.0)
        {
            self.rightMargin = 101.5;
        }
    }
    
    self.overlayViewWidth = IC_SCREEN_WIDTH - self.rightMargin;
    self.overlayViewHeight = IC_SCREEN_HEIGHT - self.topMargin - self.bottomMargin;
    self.bsOverlayView.frame = CGRectMake(0.0, self.topMargin, self.overlayViewWidth, self.overlayViewHeight);
    if (self.deviceOrientation == UIDeviceOrientationPortrait || self.deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        if (self.overlayViewWidth/self.overlayViewHeight <= 1024.0/768.0)
        {
            self.contentWidth = self.overlayViewWidth;
            self.contentHeight = self.contentWidth * 768.0 / 1024.0;
        }
        else
        {
            self.contentHeight = self.overlayViewHeight;
            self.contentWidth = self.contentHeight * 1024.0 / 768.0;
        }
    }
    else if (self.deviceOrientation == UIDeviceOrientationLandscapeLeft || self.deviceOrientation == UIDeviceOrientationLandscapeRight)
    {
        if (self.overlayViewHeight/self.overlayViewWidth <= 1024.0/768.0)
        {
            self.contentHeight = self.overlayViewHeight;
            self.contentWidth = self.contentHeight * 768.0 / 1024.0;
        }
        else
        {
            self.contentWidth = self.overlayViewWidth;
            self.contentHeight = self.contentWidth * 1024.0 / 768.0;
        }
    }
    
    UIView *topOverlayView = [self.bsOverlayView viewWithTag:101];
    UIView *topShadowView = [self.bsOverlayView viewWithTag:102];
    UIView *leftOverlayView = [self.bsOverlayView viewWithTag:201];
    UIView *leftShadowView = [self.bsOverlayView viewWithTag:202];
    UIView *rightShadowView = [self.bsOverlayView viewWithTag:301];
    UIView *rightOverlayView = [self.bsOverlayView viewWithTag:302];
    UIView *bottomShadowView = [self.bsOverlayView viewWithTag:401];
    UIView *bottomOverlayView = [self.bsOverlayView viewWithTag:402];
    
    topOverlayView.hidden = NO;
    topShadowView.hidden = NO;
    leftOverlayView.hidden = NO;
    leftShadowView.hidden = NO;
    rightShadowView.hidden = NO;
    rightOverlayView.hidden = NO;
    bottomShadowView.hidden = NO;
    bottomOverlayView.hidden = NO;
    topOverlayView.frame = CGRectMake(0.0, 0.0, self.bsOverlayView.frame.size.width, (self.bsOverlayView.frame.size.height - self.contentHeight)/2.0);
    topShadowView.frame = CGRectMake((self.bsOverlayView.frame.size.width - self.contentWidth)/2.0, topOverlayView.frame.size.height, self.contentWidth, 1.0);
    leftOverlayView.frame = CGRectMake(0.0, (self.bsOverlayView.frame.size.height - self.contentHeight)/2.0, (self.bsOverlayView.frame.size.width - self.contentWidth)/2.0, self.contentHeight);
    leftShadowView.frame = CGRectMake((self.bsOverlayView.frame.size.width - self.contentWidth)/2.0, (self.bsOverlayView.frame.size.height - self.contentHeight)/2.0 + 1.0, 1.0, self.contentHeight - 2.0);
    rightShadowView.frame = CGRectMake(self.bsOverlayView.frame.size.width - (self.bsOverlayView.frame.size.width - self.contentWidth)/2.0 - 1.0, (self.bsOverlayView.frame.size.height - self.contentHeight)/2.0 + 1.0, 1.0, self.contentHeight - 2.0);
    rightOverlayView.frame = CGRectMake(rightShadowView.frame.origin.x + 1.0, (self.bsOverlayView.frame.size.height - self.contentHeight)/2.0, (self.bsOverlayView.frame.size.width - self.contentWidth)/2.0, self.contentHeight);
    bottomShadowView.frame = CGRectMake((self.bsOverlayView.frame.size.width - self.contentWidth)/2.0, (self.bsOverlayView.frame.size.height - self.contentHeight)/2.0 + self.contentHeight - 1.0, self.bsOverlayView.frame.size.width, 1.0);
    bottomOverlayView.frame = CGRectMake(0.0, (self.bsOverlayView.frame.size.height - self.contentHeight)/2.0 + self.contentHeight, self.bsOverlayView.frame.size.width, (self.bsOverlayView.frame.size.height - self.contentHeight)/2.0);
}

- (UIImage *)didImageCroppedFinish:(UIImage *)image
{
    CGRect rect = CGRectMake(0.0, image.size.height * ((self.overlayViewHeight - self.contentHeight) / 2.0) / self.overlayViewHeight, image.size.width, image.size.height * self.contentHeight / self.overlayViewHeight);
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return resultImage;
}

- (UIView *)findView:(UIView *)view withName:(NSString *)name
{
    NSString *desc = [[view class] description];
    if ([name isEqualToString:desc])
    {
        return view;
    }
    
    for (NSInteger i = 0; i < view.subviews.count; i++)
    {
        UIView *subview = [view.subviews objectAtIndex:i];
        subview = [self findView:subview withName:name];
        if (subview)
        {
            return subview;
        }
    }
    
    return nil;
}


- (void)didShutterButtonClick:(id)sender
{
    UIButton *shutterButton = (id)sender;
    shutterButton.highlighted = NO;
    
    self.bsOverlayView.hidden = YES;
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = screenShot;
    imageView.tag = kBSCameraPickerMaskViewTag;
    [self.view addSubview:imageView];
    
    self.showsCameraControls = NO;
    [self takePicture];
}


#pragma mark -
#pragma mark UINavigationControllerDelegate Methods

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.bsOverlayView.hidden = NO;
    UIView *cameraView = [self findView:viewController.view withName:@"PLImagePickerCameraView"];
    if (cameraView == nil)
    {
        cameraView = [self findView:viewController.view withName:@"PLCameraView"];
    }
    UIView *bottomBar = [self findView:cameraView withName:@"CAMBottomBar"];
    UIButton *shutterButton = (UIButton *)[self findView:bottomBar withName:@"CAMShutterButton"];
    [shutterButton addTarget:self action:@selector(didShutterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate Methods

- (void)imagePickerControllerDidCancel:(BSCameraPickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}

- (void)imagePickerController:(BSCameraPickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:kBSCameraPickerMaskViewTag];
        [imageView removeFromSuperview];
    }];
    
    if (self.bsdelegate && [self.bsdelegate respondsToSelector:@selector(didCameraImagePickerFinished:)])
    {
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.bsdelegate didCameraImagePickerFinished:[self didImageCroppedFinish:[originalImage orientation]]];
    }
}

@end

