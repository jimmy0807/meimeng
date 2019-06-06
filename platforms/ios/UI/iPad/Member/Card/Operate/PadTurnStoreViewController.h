//
//  PadTurnStoreViewController.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadCardOperateCell.h"
#import "PadPickerViewCell.h"
#import "PadCardOperateSwitchCell.h"

@interface PadTurnStoreViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource, PadCardOperateCellDelegate, PadCardOperateSwitchCellDelegate, PadPickerViewCellDelegate>

@property (nonatomic, strong) PadMaskView *maskView;

- (id)initWithMemberCard:(CDMemberCard *)memberCard;

@end
