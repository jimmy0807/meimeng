//
//  PadCardOperateSwitchCell.h
//  Boss
//
//  Created by XiaXianBing on 16/1/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PadProjectConstant.h"

#define kPadCardOperateSwitchCellWidth          kPadMaskViewWidth
#define kPadCardOperateSwitchCellHeight         60.0
#define kPadCardOperateSwitchWidth              52.0
#define kPadCardOperateSwitchHeight             34.0

@class PadCardOperateSwitchCell;
@protocol PadCardOperateSwitchCellDelegate <NSObject>
- (void)didPadCardOperateSwitchButtonClick:(PadCardOperateSwitchCell *)cell;
@end

@interface PadCardOperateSwitchCell : UITableViewCell

@property (nonatomic, assign) BOOL isSwitchOn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id<PadCardOperateSwitchCellDelegate> delegate;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *switchButton;

@end
