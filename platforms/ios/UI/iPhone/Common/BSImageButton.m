//
//  BSImageButton.m
//  Boss
//
//  Created by lining on 16/10/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSImageButton.h"
#import <objc/runtime.h>

@interface BSImageButton ()
@property (nonatomic, strong) UIImage *normalImg;
@property (nonatomic, strong) UIImage *highlightImg;
@property (nonatomic, strong) UIImage *selctedImg;
@property (nonatomic, strong) UIImage *disableImg;

@property (nonatomic, strong) NSString *normalTitle;
@property (nonatomic, strong) NSString *highlightTitle;
@property (nonatomic, strong) NSString *selectedTitle;
@property (nonatomic, strong) NSString *disableTitle;

@property (nonatomic, strong) UILabel *mLabel;
@property (nonatomic, strong) UIImageView *mImageView;

@end

@implementation BSImageButton


- (instancetype)initWithTitle:(NSString *)title normalImageName:(NSString *)imageName
{
    return [self initWithTitle:title normalImageName:imageName highlightImageName:nil];
}

- (instancetype)initWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName highlightImageName:(NSString *)highlightImageName
{
    return [self initWithTitle:title normalImageName:normalImageName highlightImageName:highlightImageName selectedImageName:nil];
}

- (instancetype)initWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName
{
    return [self initWithTitle:title normalImageName:normalImageName highlightImageName:nil selectedImageName:selectedImageName];
}

- (instancetype)initWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName highlightImageName:(NSString *)highlightImageName selectedImageName:(NSString *)selectedImageName
{
    self = [BSImageButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
        self.imageStyle = ImageStyle_Default;
    }
    return self;
}


- (void)setImageStyle:(ImageStyle)imageStyle
{
    _imageStyle = imageStyle;
    self.padding = 2;
    [self titleLabel];
    [self imageView];
    
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self imageView];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


- (CGRect) imageRectForContentRect:(CGRect)contentRect
{
    if (CGRectEqualToRect(contentRect, CGRectZero)) {
        return CGRectZero;
    }
    CGRect rect = [super imageRectForContentRect:contentRect];
    if (self.titleLabel.text.length == 0) {
        return rect;
    }
    
    CGSize imgSize =  self.imageView.image.size;
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(contentRect.size.width, contentRect.size.height)];
    
    if (self.imageStyle == ImageStyle_Default) {
        CGFloat x = (contentRect.size.width - (titleSize.width + imgSize.width + self.padding))/ 2.0;
        rect.origin.x = x;
    }
    else if (self.imageStyle == ImageStyle_Right)
    {
        CGFloat x = (contentRect.size.width - (titleSize.width + imgSize.width + self.padding))/ 2.0;
        rect.origin.x = x + titleSize.width + self.padding;
        
    }
    else if (self.imageStyle == ImageStyle_Top)
    {
        CGFloat y = (contentRect.size.height - (titleSize.height + imgSize.height + self.padding))/ 2.0;
        rect.origin.y = y;
        rect.origin.x = (contentRect.size.width - imgSize.width)/2.0;
    }
    else if (self.imageStyle == ImageStyle_Bottom)
    {
        CGFloat y = (contentRect.size.height - (titleSize.height + imgSize.height))/ 2.0;
        rect.origin.y = y + titleSize.height + self.padding;
        rect.origin.x = (contentRect.size.width - imgSize.width)/2.0;
    }
    
    return rect;
    
}

- (CGRect) titleRectForContentRect:(CGRect)contentRect
{
    if (CGRectEqualToRect(contentRect, CGRectZero)) {
        return CGRectZero;
    }
    CGRect rect = [super titleRectForContentRect:contentRect];
    if (self.imageView.image == nil) {
        return rect;
    }
    CGSize imgSize =  self.imageView.image.size;
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(contentRect.size.width, contentRect.size.height)];
    
    if (self.imageStyle == ImageStyle_Default) {
        CGFloat x = (contentRect.size.width - (titleSize.width + imgSize.width + self.padding))/ 2.0;
        rect.origin.x = x + imgSize.width + self.padding;
    }
    else if (self.imageStyle == ImageStyle_Right)
    {
        CGFloat x = (contentRect.size.width - (titleSize.width + imgSize.width + self.padding))/ 2.0;
        rect.origin.x = x;
    }
    else if (self.imageStyle == ImageStyle_Top)
    {
        CGFloat y = (contentRect.size.height - (titleSize.height + imgSize.height + self.padding))/ 2.0;
        rect.origin.y = y + imgSize.height + self.padding;
        
//        rect.origin.x = (contentRect.size.width - titleSize.width)/2.0;
        
        rect.origin.x = 0;
        rect.size.width = contentRect.size.width;
    }
    else if (self.imageStyle == ImageStyle_Bottom)
    {
        CGFloat y = (contentRect.size.height - (titleSize.height + imgSize.height + self.padding))/ 2.0;
        rect.origin.y = y;
//        rect.origin.x = (contentRect.size.width - titleSize.width)/2.0;
        rect.origin.x = 0;
        rect.size.width = contentRect.size.width;
    }

    return rect;
}

@end

