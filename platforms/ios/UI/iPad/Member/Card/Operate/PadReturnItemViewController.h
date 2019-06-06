//
//  PadReturnItemViewController.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadProjectDetailViewController.h"

@interface PadReturnItemViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource, PadProjectDetailViewControllerDelegate>

@property (nonatomic, strong) PadMaskView *maskView;

- (id)initWithMemberCard:(CDMemberCard *)memberCard;

@end
