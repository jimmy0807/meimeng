//
//  SettingHeadCell.h
//  Boss
//
//  Created by mac on 15/7/2.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingHeadCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
+ (CGFloat)cellHeight;

@end
