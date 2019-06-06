//
//  PadMemberConsumesCell.m
//  Boss
//
//  Created by XiaXianBing on 2016-4-12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadMemberConsumesCell.h"
#import "PadProjectConstant.h"

@implementation PadMemberConsumesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat originX = 66.0;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, (kPadMemberConsumesCellHeight - 20.0)/2.0, 120.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        originX += 120.0;
        
        self.cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, (kPadMemberConsumesCellHeight - 20.0)/2.0, 96.0, 20.0)];
        self.cardLabel.backgroundColor = [UIColor clearColor];
        self.cardLabel.font = [UIFont systemFontOfSize:17.0];
        self.cardLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.cardLabel];
        originX += 96.0 + 4.0;
        
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, (kPadMemberConsumesCellHeight - 20.0)/2.0, 56.0, 20.0)];
        self.typeLabel.backgroundColor = [UIColor clearColor];
        self.typeLabel.font = [UIFont systemFontOfSize:17.0];
        self.typeLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.typeLabel];
        originX += 56.0 + 4.0;
        
        self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, (kPadMemberConsumesCellHeight - 20.0)/2.0, 96.0, 20.0)];
        self.amountLabel.backgroundColor = [UIColor clearColor];
        self.amountLabel.font = [UIFont systemFontOfSize:17.0];
        self.amountLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.amountLabel];
        originX += 96.0 + 4.0;
        
        self.dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, (kPadMemberConsumesCellHeight - 20.0)/2.0, kPadMemberAndCardInfoWidth - originX - 66.0, 20.0)];
        self.dateTimeLabel.backgroundColor = [UIColor clearColor];
        self.dateTimeLabel.textAlignment = NSTextAlignmentRight;
        self.dateTimeLabel.font = [UIFont systemFontOfSize:17.0];
        self.dateTimeLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.dateTimeLabel];
        
        self.dividerLineView = [[UIView alloc] initWithFrame:CGRectMake(66.0 + 120.0, kPadMemberConsumesCellHeight - 1.0, kPadMemberAndCardInfoWidth - 2 * 66.0 - 120.0, 1.0)];
        self.dividerLineView.backgroundColor = COLOR(236.0, 236.0, 236.0, 1.0);
        [self.contentView addSubview:self.dividerLineView];
    }
    
    return self;
}

@end
