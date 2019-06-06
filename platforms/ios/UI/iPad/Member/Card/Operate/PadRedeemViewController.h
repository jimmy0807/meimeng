//
//  PadRedeemViewController.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadCardOperateCell.h"
#import "PadSelectSingleProductViewController.h"

@interface PadRedeemViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource, PadCardOperateCellDelegate, PadSelectSingleProductViewControllerDelegate>

@property (nonatomic, strong) PadMaskView *maskView;

- (id)initWithMemberCard:(CDMemberCard *)memberCard;

@end
