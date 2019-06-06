//
//  PadProjectDetailSubRelatedCell.h
//  Boss
//
//  Created by XiaXianBing on 16/1/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"
#import "PadMaskViewConstant.h"

#define kPadDetailContentLabelWidth     (kPadMaskViewContentWidth - 2 * 20.0)

@interface PadProjectDetailSubRelatedCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *detailView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextField *changeCountTextField;

@end
