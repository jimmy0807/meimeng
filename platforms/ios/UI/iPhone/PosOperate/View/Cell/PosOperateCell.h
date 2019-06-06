//
//  OperateCell.h
//  Boss
//
//  Created by lining on 16/8/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PosOperateCell : UITableViewCell

+ (instancetype)createCell;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *notAssignTag;
@property (strong, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic, strong) CDPosOperate *operate;
@end
