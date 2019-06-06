//
//  PadProjectCell.m
//  Boss
//
//  Created by XiaXianBing on 15/10/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectCell.h"
#import "PadProjectConstant.h"
#import "PadMaskViewConstant.h"

@implementation PadProjectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        UIImageView *normalImageView = [[UIImageView alloc] init];
        normalImageView.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
        self.backgroundView = normalImageView;
        UIImageView *selectedImageView = [[UIImageView alloc] init];
        selectedImageView.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = selectedImageView;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(32.0, (kPadCustomItemCellHeight - 20.0)/2.0, kPadMaskViewWidth - 300.0 - 2 * 32.0 - 120.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        self.titleLabel.font = [UIFont systemFontOfSize:17.0];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskViewWidth - 300.0 - 32.0 - 120.0, (kPadCustomItemCellHeight - 20.0)/2.0, 120.0, 20.0)];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        self.priceLabel.font = [UIFont systemFontOfSize:16.0];
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.priceLabel];
        
        UIView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(32.0, kPadCustomItemCellHeight - 0.5, kPadMaskViewWidth - 300.0 - 2 * 32.0, 0.5)];
        lineView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
        [self.contentView addSubview:lineView];
    }
    
    return self;
}

@end
