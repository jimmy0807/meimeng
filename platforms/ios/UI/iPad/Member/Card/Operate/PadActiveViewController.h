//
//  PadActiveViewController.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"

@interface PadActiveViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PadMaskView *maskView;

- (id)initWithMemberCard:(CDMemberCard *)memberCard;

@end
