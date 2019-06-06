//
//  CBLoadingView.h
//  CardBag
//
//  Created by lining on 13-8-12.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBLoadingView : UIView

@property (nonatomic, strong) UIImageView *bgView;

+(CBLoadingView *)shareLoadingView;
-(void)show;
-(void)showInView:(UIView *)view;
-(void)showAtCenterPos:(CGPoint)point inView:(UIView *)view;
-(void)hide;

@end
