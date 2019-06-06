//
//  PadProjectDetailAmountCell.h
//  Boss
//
//  Created by XiaXianBing on 16/1/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PadProjectDetailAmountCellDelegate <NSObject>

- (void)didQuantityMinus;
- (void)didQuantityPlus;

@end

@interface PadProjectDetailAmountCell : UITableViewCell

#define kPadProjectDetailAmountCellHeight      148.0

@property (nonatomic, strong) UILabel *quantityLabel;
@property (nonatomic, strong) UITextField *quantityTextField;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UITextField *discountTextField;
@property (nonatomic, assign) id<PadProjectDetailAmountCellDelegate> delegate;

@end
