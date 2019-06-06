//
//  PadSettingSwitchCell.h
//  Boss
//
//  Created by XiaXianBing on 15/12/1.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PadSettingSwitchCell;
@protocol PadSettingSwitchCellDelegate <NSObject>
- (void)didPadSettingSwitchButtonClick:(PadSettingSwitchCell *)cell;
@end


@interface PadSettingSwitchCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *switchButton;

@property (nonatomic, assign) BOOL isSwitchOn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id<PadSettingSwitchCellDelegate> delegate;

@end
