//
//  PadPosLeftViewController.h
//  Boss
//
//  Created by lining on 15/10/15.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@protocol PadPosLeftViewControllerDelegate <NSObject>
@optional
- (void)backBtnPressed;
- (void)printBtnPressed;
- (void)giveBtnPressed;
- (void)didEditPosOperateBtnPressed;
- (void)selectedPosProduct:(CDPosBaseProduct*)product;
- (void)selectedOperate:(CDPosOperate *)operate;
@end

@interface PadPosLeftViewController : ICCommonViewController
@property(nonatomic, Weak) id<PadPosLeftViewControllerDelegate> delegate;
@property(nonatomic, strong) CDPosOperate *operate;
- (void)reloadView;
@end
