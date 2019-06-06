//
//  PadSettingRightViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/11/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadSettingConstant.h"
#import "PadSettingSwitchCell.h"
#import "PadSettingConnectionCell.h"
#import "PadPayAccountDefaultCell.h"
#import "PadPayAccountAddCell.h"
#import "PadPayAccountExistCell.h"

@protocol PadSettingRightViewControllerDelegate <NSObject>

- (void)didPadSettingInfoWithType:(kPadSettingDetailType)type;

@end

@interface PadSettingRightViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource, PadSettingSwitchCellDelegate, PadPayAccountDefaultCellDelegate, PadPayAccountAddCellDelegate, PadPayAccountExistCellDelegate>

@property (nonatomic, assign) id<PadSettingRightViewControllerDelegate> delegate;

- (id)initWithDelegate:(id<PadSettingRightViewControllerDelegate>)delegate;

- (void)reloadWithType:(kPadSettingDetailType)type;

-(void)showHandWriteBookViewController;

@end
