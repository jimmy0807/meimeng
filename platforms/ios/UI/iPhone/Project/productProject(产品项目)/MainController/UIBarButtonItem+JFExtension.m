//
//  UIBarButtonItem+JFExtension.m
//  Boss
//
//  Created by jiangfei on 16/5/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "UIBarButtonItem+JFExtension.h"

@implementation UIBarButtonItem (JFExtension)
#pragma mark 返回一个带图片的barButtonItem
-(instancetype)initWithNormalImageName:(NSString*)normalName andHightImageName:(NSString*)hightName target:(id)target action:(SEL)action
{
    self = [self init];
    if (self) {
        UIButton *btnItme = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnItme setImage:[UIImage imageNamed:normalName] forState:UIControlStateNormal];
        [btnItme setImage:[UIImage imageNamed:hightName] forState:UIControlStateHighlighted];
        [btnItme sizeToFit];
        [btnItme addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        self = [[UIBarButtonItem alloc]initWithCustomView:btnItme];
    }
    return self;
}
#pragma mark 返回一个只带文字的barButtonItem
-(instancetype)initWithTitle:(NSString*)title andTitleColor:(UIColor*)color font:(UIFont*)font
{
    self = [self init];
    if (self) {
        UILabel *labelItme = [[UILabel alloc]init];
        labelItme.text = title;
        if (!color) {
            color = [UIColor blackColor];
        }
        if (!font) {
            font = [UIFont systemFontOfSize:13];
        }
        labelItme.textColor = color;
        labelItme.font = font;
        [labelItme sizeToFit];
        self = [[UIBarButtonItem alloc]initWithCustomView:labelItme];
    }
    return self;
}
#pragma mark 返回一个带文字和图片的barButtonItem
-(instancetype)initWithNormalImageName:(NSString*)normalImageName andHightImageName:(NSString*)hightImageName  andTitle:(NSString*)title titleNormalColor:(UIColor*)Normalcolor titleHightlColor:(UIColor*)hightColor titleFont:(UIFont*)font target:(id)target action:(SEL)action
{
    self = [self init];
    if (self) {
        UIButton *btnItme = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnItme setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
        [btnItme setImage:[UIImage imageNamed:hightImageName] forState:UIControlStateHighlighted];
        [btnItme sizeToFit];
        [btnItme addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        self = [[UIBarButtonItem alloc]initWithCustomView:btnItme];
    }
    return self;
}
@end
