//
//  StaffSwitchCell.h
//  Boss
//
//  Created by mac on 15/7/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StaffSwitchCellDelegate <NSObject>
@optional
-(void)switchValueChanged:(BOOL)on;

@end

@interface StaffSwitchCell : UITableViewCell
@property (nonatomic, strong) UISwitch *cellSwitch;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic ,weak) id<StaffSwitchCellDelegate>delegate;
@end
