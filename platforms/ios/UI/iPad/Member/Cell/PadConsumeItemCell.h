//
//  PadConsumeItemCell.h
//  Boss
//
//  Created by XiaXianBing on 2016-4-20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPadConsumeItemCellWidth        300.0
#define kPadConsumeItemCellHeight       64.0

@interface PadConsumeItemCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *amountLabel;

@end
