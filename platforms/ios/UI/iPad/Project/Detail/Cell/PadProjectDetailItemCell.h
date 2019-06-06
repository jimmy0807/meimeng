//
//  PadProjectDetailItemCell.h
//  Boss
//
//  Created by XiaXianBing on 16/1/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PadProjectDetailItemCell : UITableViewCell

#define kPadProjectDetailItemCellHeight      148.0

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextField *priceTextField;

@end
