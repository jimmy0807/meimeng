//
//  BSMessageCell.h
//  Boss
//
//  Created by XiaXianBing on 15/9/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBSMessageCellHeight        80.0

@interface BSMessageCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end
