//
//  PadPosOperateCell.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPadPosOperateCellWidth        284.0
#define kPadPosOperateCellHeight       90.0

@interface PadPosOperateCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@end
