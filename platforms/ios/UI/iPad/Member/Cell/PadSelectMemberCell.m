//
//  PadSelectMemberCell.m
//  Boss
//
//  Created by XiaXianBing on 15/10/20.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadSelectMemberCell.h"

@implementation PadSelectMemberCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        UIImageView *normalImageView = [[UIImageView alloc] init];
        normalImageView.backgroundColor = [UIColor whiteColor];
        self.backgroundView = normalImageView;
        UIImageView *selectedImageView = [[UIImageView alloc] init];
        selectedImageView.backgroundColor = COLOR(233.0, 237.0, 237.0, 1.0);
        self.selectedBackgroundView = selectedImageView;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0, 0.0, (kPadSelectMemberCellWidth - 2 * 24.0)/2.0 + 20, kPadSelectMemberCellHeight)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self.contentView addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadSelectMemberCellWidth - 24.0 - self.titleLabel.frame.size.width, 0.0, self.titleLabel.frame.size.width, kPadSelectMemberCellHeight)];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.font = [UIFont systemFontOfSize:16.0];
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        self.detailLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.detailLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadSelectMemberCellHeight, kPadSelectMemberCellWidth, 1.0)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"pad_project_side_line"];
        [self.contentView addSubview:lineImageView];
    }
    
    return self;
}

@end
