//
//  HomeAddOperateMaskView.h
//  Boss
//
//  Created by jimmy on 15/12/10.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeAddOperateMaskViewDelegate <NSObject>
- (void)didBookedPosOperatePressed;
- (void)didUnBookedPosOperatePressed;
@end

@interface HomeAddOperateMaskView : UIView

- (void)setTopY:(CGFloat)posY;
- (void)show;
- (void)hide;

@property(nonatomic, weak)id<HomeAddOperateMaskViewDelegate> delegate;

@end
