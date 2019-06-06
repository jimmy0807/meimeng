//
//  BSSwitchCell.h
//  Boss
//
//  Created by XiaXianBing on 15/8/25.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSSwitchCell;
@protocol BSSwitchCellDelegate <NSObject>

- (void)didSwitchCellSwitchButtonClick:(BSSwitchCell *)switchCell;

@end

@interface BSSwitchCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *switchButton;

@property (nonatomic, assign) BOOL isSwitchOn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id<BSSwitchCellDelegate> delegate;

@end
