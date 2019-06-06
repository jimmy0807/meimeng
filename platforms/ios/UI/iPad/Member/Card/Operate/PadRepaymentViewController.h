//
//  PadRepaymentViewController.h
//  Boss
//
//  Created by XiaXianBing on 2016-4-19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"

@interface PadRepaymentViewController : ICCommonViewController

@property (nonatomic, strong) PadMaskView *maskView;

- (id)initWithMemberCard:(CDMemberCard *)memberCard;

@end
