//
//  PadCardCreateViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/10/28.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadPickerViewCell.h"
#import "PadDetailInputCell.h"

@interface PadCardCreateViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource, PadDetailInputCellDelegate, PadPickerViewCellDelegate>

@property (nonatomic, strong) PadMaskView *maskView;

- (id)initWithMember:(CDMember *)member;

@end
