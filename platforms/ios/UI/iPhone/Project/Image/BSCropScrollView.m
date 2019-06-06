//
//  BSCropScrollView.m
//  Boss
//
//  Created by XiaXianBing on 15/7/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSCropScrollView.h"

#define kBSCropScrollViewWidth      IC_SCREEN_WIDTH
#define kBSCropScrollViewHeight     (IC_SCREEN_HEIGHT - (IS_SDK7 ? 0.0 : 20.0))
#define kBSCropContentWidth         IC_SCREEN_WIDTH
#define kBSCropContentHeight        (IC_SCREEN_WIDTH * 3.0 / 4.0)


@interface BSCropScrollView ()

@property (nonatomic, strong) UIImage *imageSource;
@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation BSCropScrollView

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        self.imageSource = image;
        self.imageView = [[UIImageView alloc] initWithImage:self.imageSource];
        
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0.0, 0.0, kBSCropScrollViewWidth, kBSCropScrollViewHeight);
        self.delegate = self;
        self.clipsToBounds = NO;
        self.pagingEnabled = NO;
        self.scrollEnabled = YES;
        self.contentSize = CGSizeZero;
        self.alwaysBounceVertical = YES;
        self.alwaysBounceHorizontal = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.contentInset = UIEdgeInsetsMake((kBSCropScrollViewHeight - kBSCropContentHeight)/2.0, 0.0, (kBSCropScrollViewHeight - kBSCropContentHeight)/2.0, 0.0);
        
        CGFloat imageWidth = CGImageGetWidth(self.imageSource.CGImage);
        CGFloat imageHeight = CGImageGetHeight(self.imageSource.CGImage);
        CGFloat scrollWidth = kBSCropContentWidth;
        CGFloat scrollHeight = kBSCropContentHeight;
        CGFloat scaleX = scrollWidth / imageWidth;
        CGFloat scaleY = scrollHeight / imageHeight;
        CGFloat scaleScroll = (scaleX < scaleY ? scaleY : scaleX);
        self.maximumZoomScale = scaleScroll * 4;
        self.minimumZoomScale = scaleScroll;
        self.zoomScale = scaleScroll;
        
        [self addSubview:self.imageView];
    }
    
    return self;
}


#pragma mark -
#pragma mark Required Methods

- (UIImage *)didImageViewCroppedFinish
{
    CGRect visibleRect;
    float scale = 1.0f/self.zoomScale;
    visibleRect.origin.x = self.contentOffset.x * scale;
    visibleRect.origin.y = (self.contentOffset.y + (kBSCropScrollViewHeight - kBSCropContentHeight)/2.0) * scale;
    visibleRect.size.width = kBSCropContentWidth * scale;
    visibleRect.size.height = kBSCropContentHeight * scale;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.imageView.image.CGImage, visibleRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return croppedImage;
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
