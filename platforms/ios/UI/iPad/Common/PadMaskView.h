//
//  PadMaskView.h
//  Boss
//
//  Created by XiaXianBing on 15/10/22.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBRotateNavigationController.h"
#import "PadMaskViewConstant.h"

@class PadMaskView;
@protocol PadMaskViewDelegate <NSObject>

- (void)didPadMaskViewBackgroundClick:(PadMaskView *)maskView;

@end

@interface PadMaskView : UIView

@property (nonatomic, strong) CBRotateNavigationController *navi;
@property (nonatomic, weak) id<PadMaskViewDelegate> delegate;

- (void)show;
- (void)hidden;
- (void)removeSubviews;

@end
