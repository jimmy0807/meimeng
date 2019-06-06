//
//  OperateMonthCell.h
//  Boss
//
//  Created by lining on 16/8/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PosOperateMonthCell : UITableViewCell
+ (instancetype) createCell;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;

@property (strong, nonatomic) CDPosMonthIncome *income;
@end
