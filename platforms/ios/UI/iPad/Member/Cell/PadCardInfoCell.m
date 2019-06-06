//
//  PadCardInfoCell.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadCardInfoCell.h"
#import "PadProjectConstant.h"

@implementation PadCardInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0, 32.0, kPadMemberAndCardInfoWidth - 2 * 66.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0, 32.0 + 20.0 + 12.0, kPadMemberAndCardInfoWidth - 2 * 66.0, 24.0)];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.font = [UIFont systemFontOfSize:24.0];
        self.detailLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.detailLabel];
        
        self.secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0 + (kPadMemberAndCardInfoWidth - 2 * 66.0 - 12.0)/2.0 + 12.0, 32.0, (kPadMemberAndCardInfoWidth - 2 * 66.0 - 12.0)/2.0, 20.0)];
        self.secondTitleLabel.backgroundColor = [UIColor clearColor];
        self.secondTitleLabel.font = [UIFont systemFontOfSize:15.0];
        self.secondTitleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.secondTitleLabel];
        
        self.secondDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0 + (kPadMemberAndCardInfoWidth - 2 * 66.0 - 12.0)/2.0 + 12.0, 32.0 + 20.0 + 12.0, (kPadMemberAndCardInfoWidth - 2 * 66.0 - 12.0)/2.0, 24.0)];
        self.secondDetailLabel.backgroundColor = [UIColor clearColor];
        self.secondDetailLabel.font = [UIFont systemFontOfSize:24.0];
        self.secondDetailLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.secondDetailLabel];
        
        UIImage *arrowImage = [UIImage imageNamed:@"pad_member_arrow"];
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMemberAndCardInfoWidth - 66.0 - arrowImage.size.width, (kPadCardInfoCellHeight - arrowImage.size.height)/2.0, arrowImage.size.width, arrowImage.size.height)];
        self.arrowImageView.backgroundColor = [UIColor clearColor];
        self.arrowImageView.image = arrowImage;
        [self.contentView addSubview:self.arrowImageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(66.0, kPadCardInfoCellHeight - 1.0, kPadMemberAndCardInfoWidth - 2 * 66.0, 1.0)];
        lineView.backgroundColor = COLOR(236.0, 236.0, 236.0, 1.0);
        [self.contentView addSubview:lineView];
    }
    
    return self;
}

@end
