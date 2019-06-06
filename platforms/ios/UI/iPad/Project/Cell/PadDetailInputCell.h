//
//  PadDetailInputCell.h
//  Boss
//
//  Created by XiaXianBing on 16/1/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PadDetailInputCell;
@protocol PadDetailInputCellDelegate <NSObject>

- (void)didShowAndHidePickerView:(PadDetailInputCell *)cell;

@end


#define kPadDetailInputCellHeight      120.0

@interface PadDetailInputCell : UITableViewCell

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIImageView *downImageView;
@property (nonatomic, strong) UIButton *contentButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, assign) id<PadDetailInputCellDelegate> delegate;


@end
