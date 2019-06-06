//
//  PadReserveCell.h
//  Boss
//
//  Created by XiaXianBing on 15/12/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PadMaskViewConstant.h"

#define kPadReserveCellWidth       kPadMaskViewWidth
#define kPadReserveCellHeight      72.0

@interface PadReserveCell : UITableViewCell

@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *technicianLabel;
@property (nonatomic, strong) UILabel *itemLabel;

- (void)isSelectImageViewSelected:(BOOL)isSelect;

@end
