//
//  PadMorePayModeCell.m
//  Boss
//
//  Created by XiaXianBing on 15/11/4.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadMorePayModeCell.h"

@implementation PadMorePayModeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = COLOR(252.0, 206.0, 29.0, 1.0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(32.0, (kPadMorePayModeCellHeight - 20.0)/2.0, kPadMorePayModeCellWidth - 2 * 32.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.titleLabel.textColor = COLOR(159.0, 119.0, 11.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadMorePayModeCellHeight - 0.5, kPadMorePayModeCellWidth, 0.5)];
        lineImageView.backgroundColor = COLOR(227.0, 185.0, 22.0, 1.0);
        [self.contentView addSubview:lineImageView];
    }
    
    return self;
}

@end
