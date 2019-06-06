//
//  MemberCardAmountViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/8/21.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCardAmountViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithCardAmount:(CGFloat)cardAmount presentAmount:(CGFloat)presentAmount;

@end
