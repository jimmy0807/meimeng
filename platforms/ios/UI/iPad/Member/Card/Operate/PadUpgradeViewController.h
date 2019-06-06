//
//  PadUpgradeViewController.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadPickerViewCell.h"
#import "PadCardOperateCell.h"

@interface PadUpgradeViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource, PadPickerViewCellDelegate, PadCardOperateCellDelegate>

@property (nonatomic, strong) PadMaskView *maskView;

- (id)initWithMemberCard:(CDMemberCard *)memberCard;

@end
