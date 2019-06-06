//
//  PadMemberDetailCell.m
//  Boss
//
//  Created by XiaXianBing on 2016-4-12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadMemberDetailCell.h"
#import "PadProjectConstant.h"

@implementation PadMemberDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0, (kPadMemberDetailCellHeight - 20.0)/2.0, 120.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0 + 120.0, (kPadMemberDetailCellHeight - 20.0)/2.0, kPadMemberAndCardInfoWidth - 2 * 66.0 - 120.0, 20.0)];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.font = [UIFont systemFontOfSize:17.0];
        self.detailLabel.adjustsFontSizeToFitWidth = YES;
        self.detailLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.detailLabel.minimumScaleFactor = 14.0/20.0;
        self.detailLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.detailLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(66.0, kPadMemberDetailCellHeight - 1.0, kPadMemberAndCardInfoWidth - 2 * 66.0, 1.0)];
        lineView.backgroundColor = COLOR(236.0, 236.0, 236.0, 1.0);
        [self.contentView addSubview:lineView];
    }
    
    return self;
}

@end
