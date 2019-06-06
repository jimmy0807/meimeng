//
//  PadMemberRelativesCell.m
//  Boss
//
//  Created by XiaXianBing on 2016-4-12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadMemberRelativesCell.h"
#import "PadProjectConstant.h"

@implementation PadMemberRelativesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0, (kPadMemberRelativesCellHeight - 20.0)/2.0, 120.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0 + 120.0, (kPadMemberRelativesCellHeight - 20.0)/2.0, 96.0, 20.0)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:17.0];
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        self.nameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.nameLabel.minimumScaleFactor = 14.0/17.0;
        self.nameLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.nameLabel];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0 + 120.0 + 96.0 + 4.0, (kPadMemberRelativesCellHeight - 20.0)/2.0, kPadMemberAndCardInfoWidth - 2 * 66.0 - 120.0 - 72.0 - 4.0, 20.0)];
        self.phoneLabel.backgroundColor = [UIColor clearColor];
        self.phoneLabel.font = [UIFont systemFontOfSize:17.0];
        self.phoneLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.phoneLabel];
        
        self.dividerLineView = [[UIView alloc] initWithFrame:CGRectMake(66.0 + 120.0, kPadMemberRelativesCellHeight - 1.0, kPadMemberAndCardInfoWidth - 2 * 66.0 - 120.0, 1.0)];
        self.dividerLineView.backgroundColor = COLOR(236.0, 236.0, 236.0, 1.0);
        [self.contentView addSubview:self.dividerLineView];
    }
    
    return self;
}

@end
