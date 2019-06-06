//
//  PadCustomerCell.h
//  Boss
//
//  Created by XiaXianBing on 2016-2-23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPadCustomerCellWidth        284.0
#define kPadCustomerCellHeight       90.0

@interface PadCustomerCell : UITableViewCell

@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *numberLabel;

- (void)isSelectImageViewSelected:(BOOL)isSelect;

@end
