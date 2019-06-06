//
//  PadProjectTypeCell.m
//  Boss
//
//  Created by XiaXianBing on 15/10/20.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectTypeCell.h"
#import "PadProjectConstant.h"

@implementation PadProjectTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        UIImageView *normalImageView = [[UIImageView alloc] init];
        normalImageView.backgroundColor = COLOR(245.0, 248.0, 248.0, 1.0);
        self.backgroundView = normalImageView;
        UIImageView *selectedImageView = [[UIImageView alloc] init];
        selectedImageView.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = selectedImageView;
        
        UIImage *arrowImage = [UIImage imageNamed:@"pad_category_arrow"];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, (kPadProjectCategoryCellHeight - 20.0)/2.0, kPadProjectCategoryCellWidth - 2 * 16.0 - arrowImage.size.width - 4.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:self.titleLabel];
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadProjectCategoryCellWidth - 16.0 - arrowImage.size.width, (kPadProjectCategoryCellHeight - arrowImage.size.height)/2.0, arrowImage.size.width, arrowImage.size.height)];
        self.arrowImageView.backgroundColor = [UIColor clearColor];
        self.arrowImageView.image = arrowImage;
        [self.contentView addSubview:self.arrowImageView];
        
        UIView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(16.0, kPadProjectCategoryCellHeight - 1.0, kPadProjectCategoryCellWidth - 16.0, 1.0)];
        lineView.backgroundColor = COLOR(221.0, 221.0, 221.0, 1.0);
        [self.contentView addSubview:lineView];
    }
    
    return self;
}

@end
