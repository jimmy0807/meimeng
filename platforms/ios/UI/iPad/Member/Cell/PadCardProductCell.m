//
//  PadCardProductCell.m
//  Boss
//
//  Created by XiaXianBing on 2016-4-12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadCardProductCell.h"
#import "PadProjectConstant.h"

@implementation PadCardProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0, (kPadCardProductCellHeight - 20.0)/2.0, kPadMemberAndCardInfoWidth - 2 * 66.0 - 2 * 20.0 - 120.0 - 64.0 + 20, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:17.0];
        self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.titleLabel];
        
        self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 20.0, (kPadCardProductCellHeight - 20.0)/2.0, 44.0, 20.0)];
        self.amountLabel.backgroundColor = [UIColor clearColor];
        self.amountLabel.font = [UIFont systemFontOfSize:17.0];
        self.amountLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.amountLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.amountLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.amountLabel.frame.origin.x + self.amountLabel.frame.size.width + 20.0, (kPadCardProductCellHeight - 20.0)/2.0, 120.0, 20.0)];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.priceLabel.font = [UIFont systemFontOfSize:17.0];
        self.priceLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.priceLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.priceLabel];
        
        UIView *dividerLineView = [[UIView alloc] initWithFrame:CGRectMake(66.0, kPadCardProductCellHeight - 1.0, kPadMemberAndCardInfoWidth - 2 * 66.0, 1.0)];
        dividerLineView.backgroundColor = COLOR(236.0, 236.0, 236.0, 1.0);
        [self.contentView addSubview:dividerLineView];
    }
    
    return self;
}

@end
