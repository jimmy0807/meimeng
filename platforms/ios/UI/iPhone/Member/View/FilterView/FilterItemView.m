//
//  FilterItemView.m
//  Boss
//
//  Created by lining on 16/5/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "FilterItemView.h"

@implementation FilterItemView

- (instancetype)initWithTitle:(NSString *)title
{
    return [self initWithTitle:title imgName:@"member_filter_arrow_down.png" selectedImgName:@"member_filter_arrow_up.png"];
}

- (instancetype)initWithTitle:(NSString *)title imgName:(NSString *)imgName selectedImgName:(NSString *)selectedImgName
{
    self = [super init];
    if (self) {
        self.normalBtn = [[RightDrawableBtn alloc] initWithTitle:title font:[UIFont systemFontOfSize:15] imageName:imgName selectedImageName:selectedImgName];
        [self.normalBtn addTarget:self action:@selector(didNormalBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.normalBtn];
        
        [self.normalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsZero);
        }];
        
        
        self.selectedBtn = [self buttonWithTitle:@""];
        self.selectedBtn.hidden = true;
        [self.selectedBtn addTarget:self action:@selector(didSelectedBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectedBtn];
        [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.centerOffset(CGPointZero);
        }];
    }
    return self;
}

- (UIButton *)buttonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title.length > 0) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button setTitleColor:COLOR(0, 143, 220, 1) forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"member_filter_selected_bg"] forState:UIControlStateNormal];
    return button;
}

#pragma mark - button action
- (void) didNormalBtnPressed:(UIButton *)btn
{
    self.normalBtn.selected = !self.normalBtn.selected;
    if ([self.delegate respondsToSelector:@selector(didArrowBtnPressed:)]) {
        [self.delegate didArrowBtnPressed:self];
    }
}

- (void) didSelectedBtnPressed:(UIButton *)btn
{
    btn.hidden = true;
    self.normalBtn.hidden = false;
    self.normalBtn.selected = false;
    if ([self.delegate respondsToSelector:@selector(didCancelSelectedBtnPressed:)]) {
        [self.delegate didCancelSelectedBtnPressed:self];
    }
}
@end



@interface RightDrawableBtn ()
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *font;

@end

@implementation RightDrawableBtn

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
    self = [RightDrawableBtn buttonWithType:UIButtonTypeCustom];
    if (self) {
        if (font == nil) {
            font = [UIFont systemFontOfSize:17];
        }
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
    CGRect rect = [super imageRectForContentRect:contentRect];
    if (self.title == nil) {
        return rect;
    }
    
    CGSize imgSize =  self.normalImage.size;
    CGSize titleSize = [self.title sizeWithFont:self.font constrainedToSize:CGSizeMake(contentRect.size.width, contentRect.size.height)];
    
    CGFloat x = (contentRect.size.width - (titleSize.width + imgSize.width))/ 2.0;
    
//    CGRect rect1 =  CGRectMake(x + titleSize.width + 2, (contentRect.size.height - imgSize.height)/2.0, imgSize.width, imgSize.height);
    rect.origin.x = x + titleSize.width + 2;
    return rect;
    
}

- (CGRect) titleRectForContentRect:(CGRect)contentRect
{
    if (CGRectEqualToRect(contentRect, CGRectZero)) {
        return CGRectZero;
    }
    CGRect rect = [super titleRectForContentRect:contentRect];
    if (self.normalImage == nil) {
        return rect;
    }
    CGSize imgSize =  self.normalImage.size;
    CGSize titleSize = [self.title sizeWithFont:self.font constrainedToSize:CGSizeMake(contentRect.size.width, contentRect.size.height)];

    CGFloat x = (contentRect.size.width - (titleSize.width + imgSize.width))/ 2.0;
    
//    CGRect rect1 = CGRectMake(x, (contentRect.size.height - titleSize.height)/2.0, titleSize.width, titleSize.height);
    rect.origin.x = x;
    return rect;
}

@end
