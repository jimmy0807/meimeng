//
//  OperateHeadCell.h
//  Boss
//
//  Created by lining on 16/5/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperateHeadCell : UITableViewCell
+ (instancetype)createCell;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *valueLabel;

@end
