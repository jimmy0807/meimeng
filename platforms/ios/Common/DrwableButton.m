//
//  DrwableButton.m
//  Boss
//
//  Created by lining on 16/6/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "DrwableButton.h"

@interface DrwableButton ()
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *font;

@end

@implementation DrwableButton
- (instancetype)initWithTitle:(NSString *)title
{
    UIFont *font = [UIFont systemFontOfSize:15.0];
    return [self initWithTitle:title font:font];
}

- (instancetype)initWithTitle:(NSString *)title font:(UIFont *)font
{
    return [self initWithTitle:title font:font imageName:@"member_filter_arrow_down.png" selectedImageName:@"member_filter_arrow_up.png"];
}

- (instancetype)initWithTitle:(NSString *)title font:(UIFont *)font imageName:(NSString *)name selectedImageName:(NSString *)selectedName
{
    self = [DrwableButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.titleLabel.font = font;
        [self setTitle:title forState:UIControlStateNormal];
        
        UIImage *normalImg = [UIImage imageNamed:name];
        UIImage *selectedImg = [UIImage imageNamed:selectedName];
        
        [self setImage:normalImg forState:UIControlStateNormal];
        
        
        [self setImage:[UIImage imageNamed:selectedName] forState:UIControlStateSelected];
        
        [self setTitleColor:COLOR(72, 72, 72, 1) forState:UIControlStateNormal];
        //        Color.rgb(0, 143, 220)
        [self setTitleColor:COLOR(0, 143, 220, 1) forState:UIControlStateSelected];
        
        self.title = title;
        self.font = font;
        self.normalImage = normalImg;
        self.selectedImage = selectedImg;
        
        
    }
    
    return self;
}


- (void)setHighlighted:(BOOL)highlighted
{
    
}

- (CGRect) imageRectForContentRect:(CGRect)contentRect
{
    if (CGRectEqualToRect(contentRect, CGRectZero)) {
        return CGRectZero;
    }
    
    CGSize imgSize =  self.normalImage.size;
    CGSize titleSize = [self.title sizeWithFont:self.font constrainedToSize:CGSizeMake(contentRect.size.width, contentRect.size.height)];
    
    CGFloat x = (contentRect.size.width - (titleSize.width + 2 + imgSize.width))/ 2.0;
    
    return CGRectMake(x + titleSize.width + 2, (contentRect.size.height - imgSize.height)/2.0, imgSize.width, imgSize.height);
    
}

- (CGRect) titleRectForContentRect:(CGRect)contentRect
{
    if (CGRectEqualToRect(contentRect, CGRectZero)) {
        return CGRectZero;
    }
    CGSize imgSize =  self.normalImage.size;
    CGSize titleSize = [self.title sizeWithFont:self.font constrainedToSize:CGSizeMake(contentRect.size.width, contentRect.size.height)];
    
    
    CGFloat x = (contentRect.size.width - (titleSize.width + 2 + imgSize.width))/ 2.0;
    
    return CGRectMake(x, (contentRect.size.height - titleSize.height)/2.0, titleSize.width, titleSize.height);
}

@end
