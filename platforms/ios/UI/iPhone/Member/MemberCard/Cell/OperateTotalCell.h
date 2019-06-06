//
//  OperateTotalCell.h
//  Boss
//
//  Created by lining on 16/5/9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperateTotalCell : UITableViewCell
+ (instancetype)createCell;
@property (strong, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@end
