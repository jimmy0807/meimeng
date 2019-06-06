//
//  GestureUnlockViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/3/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "GestureUnlockView.h"

@class GestureUnlockViewController;
@protocol GestureUnlockViewControllerDelegate <NSObject>
@optional
- (void)passStep:(GestureUnlockViewController *)gestureUnlockVC;
- (void)addGestureSuccess:(GestureUnlockViewController *)gestureUnlockVC;
- (void)setGestureSuccess:(GestureUnlockViewController *)gestureUnlockVC;
@end

@interface GestureUnlockViewController : ICCommonViewController <GestureUnlockViewDelegate>

@property (nonatomic, assign) GestureUnlockType type;
@property (nonatomic, assign) id<GestureUnlockViewControllerDelegate> delegate;

@end
