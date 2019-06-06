//
//  UIBarButtonItem+JFExtension.h
//  Boss
//
//  Created by jiangfei on 16/5/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (JFExtension)

/**
 *  返回一个带图片的barButtonItem
 *
 *  @param normalName 普通状态下的图片名
 *  @param hightName  高亮状态下的图片名
 *  @param target     调用哪个控制器的方法
 *  @param action     方法名
 */
-(instancetype)initWithNormalImageName:(NSString*)normalName andHightImageName:(NSString*)hightName target:(id)target action:(SEL)action;
/**
 *  返回一个只带文字的barButtonItem
 */
-(instancetype)initWithTitle:(NSString*)title andTitleColor:(UIColor*)color font:(UIFont*)font;
/**
 *  返回一个带文字和图片的barButtonItem;
 *
 *  @param normalImageName 普通状态下的图片名
 *  @param hightImageName  高亮状态下的图片名
 *  @param title           标题名
 *  @param Normalcolor     普通状态下的标题颜色
 *  @param hightColor      高亮状态下的标题颜色
 *  @param font            标题文字
 *  @param target          调用哪个控制器的方法
 *  @param action          方法名
 *
 */
-(instancetype)initWithNormalImageName:(NSString*)normalImageName andHightImageName:(NSString*)hightImageName  andTitle:(NSString*)title titleNormalColor:(UIColor*)Normalcolor titleHightlColor:(UIColor*)hightColor titleFont:(UIFont*)font target:(id)target action:(SEL)action;

@end
