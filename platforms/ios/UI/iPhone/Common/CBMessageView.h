//
//  CBMessageView.h
//  CardBag
//
//  Created by jimmy on 13-8-6.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBMessageView;
@protocol CBMessageViewDelegate <NSObject>
@optional
- (void)messageViewWillDisAppear:(CBMessageView*)view;
@end

@interface CBMessageView : UIView
{
    NSTimer* timer;
    BOOL isForeverTitle;
}

@property(nonatomic, strong) UIImageView* backgroundImageView;
@property(nonatomic, Weak) id<CBMessageViewDelegate> delegate;

- (id)initWithTitle:(NSString*)title KeyWordTextArray:(NSArray*)array orTextString:(NSString*)str withColor:(UIColor*)color;
- (id)initWithTitle:(NSString*)title;
- (id)initWithTitle:(NSString *)title afterTimeHide:(double)time;
- (void)showAtCenterPos:(CGPoint)point;
- (void)show;
- (void)hide;
- (void)setForeverShow;
- (void)showInView:(UIView*)view;

@end

