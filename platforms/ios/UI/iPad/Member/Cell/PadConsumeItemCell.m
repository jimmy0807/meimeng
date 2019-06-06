//
//  PadConsumeItemCell.m
//  Boss
//
//  Created by XiaXianBing on 2016-4-20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadConsumeItemCell.h"

@implementation PadConsumeItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0, (kPadConsumeItemCellHeight - 20.0)/2.0, kPadConsumeItemCellWidth - 2 * 24.0 - 12.0 - 64.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.font = IOS7FONT(15.0);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadConsumeItemCellWidth - 24.0 - 12.0 - 64.0, (kPadConsumeItemCellHeight - 20.0)/2.0, 64.0, 20.0)];
        self.amountLabel.backgroundColor = [UIColor clearColor];
        self.amountLabel.numberOfLines = 1;
        self.amountLabel.font = IOS7FONT(15.0);
        self.amountLabel.textAlignment = NSTextAlignmentRight;
        self.amountLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.amountLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadConsumeItemCellHeight - 0.5, kPadConsumeItemCellWidth, 0.5)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"pad_project_side_line"];
        [self.contentView addSubview:lineImageView];
    }
    
    return self;
}

@end
