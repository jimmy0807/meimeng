//
//  PadMemberConsumesCell.h
//  Boss
//
//  Created by XiaXianBing on 2016-4-12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPadMemberConsumesCellHeight   80.0

@interface PadMemberConsumesCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *cardLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *dateTimeLabel;
@property (nonatomic, strong) UIView *dividerLineView;

@end
