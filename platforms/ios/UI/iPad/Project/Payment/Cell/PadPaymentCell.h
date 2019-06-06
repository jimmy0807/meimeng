//
//  PadPaymentCell.h
//  Boss
//
//  Created by XiaXianBing on 15/10/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PadMaskView.h"

#define kPadPaymentCellWidth        kPadMaskViewWidth
#define kPadPaymentCellHeight       60.0

@class PadPaymentCell;
@protocol PadPaymentCellDelegate <NSObject>

- (void)didPadPaymentCellCancel:(PadPaymentCell *)cell;

@end

@interface PadPaymentCell : UITableViewCell

@property (nonatomic, strong) UIImageView *checkImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) id<PadPaymentCellDelegate> delegate;

@end
