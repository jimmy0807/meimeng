//
//  BSSuccessViewController.h
//  Boss
//
//  Created by lining on 16/9/27.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "BSSuccessBtnView.h"

#define kPushToCashier  @"kPushToCashier"
#define kPushToAssign   @"kPushToAssign"
#define kPushToGive     @"kPushToSend"

@protocol BSSuccessViewControllerDelegate <NSObject>

@optional
- (void)didCashierBtnPressed;
- (void)didAssignBtnPressed;
- (void)didSendBtnPressed;

@end

@interface BSSuccessViewController : ICCommonViewController
+ (instancetype)createViewControllerWithQRUrl:(NSString *)url;
+ (instancetype)createViewControllerWithTopTip:(NSString *)topTip contentTitle:(NSString *)title detailTitle:(NSString *)detailTitle;
@property (weak, nonatomic) id<BSSuccessViewControllerDelegate>delegate;
@property (nonatomic, assign) ViewShowStyle style;

@property (nonatomic, strong) CDPosOperate *operate;
@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) NSNumber *operateID;
@end
