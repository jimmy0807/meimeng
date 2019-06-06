//
//  PadCardOperateCell.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PadCardOperateCell;
@protocol PadCardOperateCellDelegate <NSObject>
- (void)didContentButtonClick:(PadCardOperateCell *)cell;
@end

@interface PadCardOperateCell : UITableViewCell

#define kPadCardOperateCellHeight      120.0

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *contentButton;
@property (nonatomic, strong) UITextField *contentTextField;
@property (nonatomic, strong) UIImageView *downImageView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id<PadCardOperateCellDelegate> delegate;

@end
