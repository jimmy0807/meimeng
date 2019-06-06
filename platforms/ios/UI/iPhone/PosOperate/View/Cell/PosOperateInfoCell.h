//
//  OperateInfoCell.h
//  Boss
//
//  Created by lining on 16/8/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PosOperateInfoCell : UITableViewCell
+ (instancetype) createCell;

@property (nonatomic, strong) CDPosOperate *operate;

@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *memberLabel;
@property (strong, nonatomic) IBOutlet UILabel *operatorLabel;
@property (strong, nonatomic) IBOutlet UIImageView *assignTag;

@end
