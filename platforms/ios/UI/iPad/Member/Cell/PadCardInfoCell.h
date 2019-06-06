//
//  PadCardInfoCell.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPadCardInfoCellHeight        118.0

@interface PadCardInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *secondTitleLabel;
@property (nonatomic, strong) UILabel *secondDetailLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end
