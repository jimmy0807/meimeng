//
//  AlbumViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/19.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "AlbumViewController.h"
#import "BSCropScrollView.h"

#define ZOOM_STEP       1.5
#define ZOOM_VIEW_TAG   100
#define kAlbumWidth     IC_SCREEN_WIDTH
#define kAlbumHeight    (IC_SCREEN_WIDTH * 3 / 4.0)

@interface AlbumViewController ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) id<AlbumViewControllerDelegate> delegate;

@property (nonatomic, strong) BSCropScrollView *cropScrollView;
@property (nonatomic, strong) UIView *overlayView;

@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, assign) CGFloat maxScale;

@end

@implementation AlbumViewController

- (id)initWithAlbumImage:(UIImage *)image delegate:(id<AlbumViewControllerDelegate>)delegate
{
    self = [super initWithNibName:NIBCT(@"AlbumViewController") bundle:nil];
    if (self != nil)
    {
        self.image = image;
        self.delegate = delegate;
        
        self.minScale = 1.0;
        self.maxScale = 5.0;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT - (IS_SDK7 ? 0.0 : 20.0));
    
    self.cropScrollView = [[BSCropScrollView alloc] initWithImage:self.image];
//    self.cropScrollView.frame = CGRectMake((self.view.frame.size.width - self.cropScrollView.bounds.size.width)/2.0, (self.view.frame.size.height - self.cropScrollView.bounds.size.height)/2.0, self.cropScrollView.bounds.size.width, self.cropScrollView.bounds.size.height);
    self.cropScrollView.clipsToBounds = NO;
//    [self.cropScrollView setContentOffset:CGPointMake(0, 0-146)];
    [self.view addSubview:self.cropScrollView];
    [self initOverlayView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0.0, self.view.frame.size.height - 36.0 - 20.0, 72.0, 32.0);
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [cancelButton setTitle:LS(@"Cancel") forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(didCancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(IC_SCREEN_WIDTH - 72.0, self.view.frame.size.height - 36.0 - 20.0, 72.0, 32.0);
    sureButton.backgroundColor = [UIColor clearColor];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [sureButton setTitle:LS(@"OK") forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(didSureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
}

- (void)initOverlayView
{
    self.overlayView = [[UIView alloc] initWithFrame:self.view.frame];
    self.overlayView.backgroundColor = [UIColor clearColor];
    self.overlayView.userInteractionEnabled = NO;
    [self.view addSubview:self.overlayView];
    
    UIView *topOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, (self.view.frame.size.height - kAlbumHeight)/2.0)];
    topOverlayView.backgroundColor = [UIColor blackColor];
    topOverlayView.alpha = 0.5;
    topOverlayView.userInteractionEnabled = NO;
    [self.overlayView addSubview:topOverlayView];
    
    UIView *topShadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0, (self.overlayView.frame.size.height - kAlbumHeight)/2.0, IC_SCREEN_WIDTH, 1.0)];
    topShadowView.backgroundColor = [UIColor whiteColor];
    topShadowView.alpha = 0.5;
    [self.overlayView addSubview:topShadowView];
    
    UIView *leftShadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0, (self.overlayView.frame.size.height - kAlbumHeight)/2.0 + 1.0, 1.0, kAlbumHeight - 2.0)];
    leftShadowView.backgroundColor = [UIColor whiteColor];
    leftShadowView.alpha = 0.5;
    [self.overlayView addSubview:leftShadowView];
    
    UIView *rightShadowView = [[UIView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - 1.0, (self.overlayView.frame.size.height - kAlbumHeight)/2.0 + 1.0, 1.0, kAlbumHeight - 2.0)];
    rightShadowView.backgroundColor = [UIColor whiteColor];
    rightShadowView.alpha = 0.5;
    [self.overlayView addSubview:rightShadowView];
    
    UIView *bottomShadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0, (self.overlayView.frame.size.height - kAlbumHeight)/2.0 + kAlbumHeight - 1.0, IC_SCREEN_WIDTH, 1.0)];
    bottomShadowView.backgroundColor = [UIColor whiteColor];
    bottomShadowView.alpha = 0.5;
    [self.overlayView addSubview:bottomShadowView];
    
    UIView *bottomOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.overlayView.frame.size.height - (self.overlayView.frame.size.height - kAlbumHeight)/2.0, IC_SCREEN_WIDTH, (self.overlayView.frame.size.height - kAlbumHeight)/2.0)];
    bottomOverlayView.backgroundColor = [UIColor blackColor];
    bottomOverlayView.alpha = 0.5;
    [self.overlayView addSubview:bottomOverlayView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark Required Methods

- (void)didCancelButtonClick:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didSureButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAlbumImageEditFinished:)])
    {
        [self.delegate didAlbumImageEditFinished:[self.cropScrollView didImageViewCroppedFinish]];
    }
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
}


@end
