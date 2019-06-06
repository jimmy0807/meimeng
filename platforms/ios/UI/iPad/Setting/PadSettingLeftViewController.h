//
//  PadSettingLeftViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/11/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadSettingConstant.h"

@protocol PadSettingLeftViewControllerDelegate <NSObject>

- (void)backPaymentView;
- (void)backHomeLeftSideBar;
- (void)reloadSettingDetailWithType:(kPadSettingDetailType)type;
-(void)showHandWriteBookVC;

@end

@interface PadSettingLeftViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) kPadSettingViewType viewType;
@property (nonatomic, assign) id<PadSettingLeftViewControllerDelegate> delegate;

- (id)initWithDelegate:(id<PadSettingLeftViewControllerDelegate>)delegate;

@end
