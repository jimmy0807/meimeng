//
//  CBIsNoneView.h
//  CardBag
//
//  Created by chen yan on 13-9-17.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBIsNoneView;
@protocol CBIsNoneViewDelegate <NSObject>
- (void)isNoneViewButtonClick:(CBIsNoneView *)isNoneView;
@end


@interface CBIsNoneView : UIView

@property (nonatomic, assign) id<CBIsNoneViewDelegate> delegate;

- (id)initWithImage:(UIImage *)image message:(NSString *)message buttonTitle:(NSString *)buttonTitle;
- (void)showNoneViewInView:(UIView *)view;

@end
