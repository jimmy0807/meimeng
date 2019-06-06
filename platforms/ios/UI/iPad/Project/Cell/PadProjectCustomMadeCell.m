//
//  PadProjectCustomMadeCell.m
//  Boss
//
//  Created by XiaXianBing on 2016-4-18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadProjectCustomMadeCell.h"
#import "PadProjectConstant.h"

@implementation PadProjectCustomMadeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *normalImageView = [[UIImageView alloc] init];
        normalImageView.backgroundColor = COLOR(245.0, 248.0, 248.0, 1.0);
        self.backgroundView = normalImageView;
        
        UIImage *iconImage = [UIImage imageNamed:@"pad_category_custom_price"];
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, (kPadProjectCategoryCellHeight - iconImage.size.height)/2.0, iconImage.size.width, iconImage.size.height)];
        self.iconImageView.backgroundColor = [UIColor clearColor];
        self.iconImageView.image = iconImage;
        [self.contentView addSubview:self.iconImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0 + iconImage.size.width + 16.0, (kPadProjectCategoryCellHeight - 20.0)/2.0, kPadProjectCategoryCellWidth - 2 * 20.0 - iconImage.size.width + 16.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = COLOR(168.0, 205.0, 205.0, 1.0);
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:self.titleLabel];
        
        UIView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(16.0, kPadProjectCategoryCellHeight - 1.0, kPadProjectCategoryCellWidth - 16.0, 1.0)];
        lineView.backgroundColor = COLOR(221.0, 221.0, 221.0, 1.0);
        [self.contentView addSubview:lineView];
    }
    
    return self;
}

@end
