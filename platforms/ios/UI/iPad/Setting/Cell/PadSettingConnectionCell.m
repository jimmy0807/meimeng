//
//  PadSettingConnectionCell.m
//  Boss
//
//  Created by XiaXianBing on 15/12/1.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadSettingConnectionCell.h"
#import "UIImage+Resizable.h"
#import "PadSettingConstant.h"

#define kPadSettingConnectionCellWidth      (kPadSettingRightSideViewWidth - 2 * 32.0)
#define kPadSettingConnectionCellHeight     60.0

@implementation PadSettingConnectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        UIImageView *normalImageView = [[UIImageView alloc] init];
        normalImageView.backgroundColor = [UIColor clearColor];
        normalImageView.image = [[UIImage imageNamed:@"pad_setting_cell_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
        self.backgroundView = normalImageView;
        UIImageView *selectedImageView = [[UIImageView alloc] init];
        selectedImageView.backgroundColor = [UIColor clearColor];
        selectedImageView.image = [[UIImage imageNamed:@"pad_setting_cell_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
        self.selectedBackgroundView = selectedImageView;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, (kPadSettingConnectionCellHeight - 20.0)/2.0, kPadSettingConnectionCellWidth - 2 * 20.0 - 132.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadSettingConnectionCellWidth - 20.0 - 132.0, (kPadSettingConnectionCellHeight - 20.0)/2.0, 132.0, 20.0)];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        self.detailLabel.font = [UIFont systemFontOfSize:16.0];
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.detailLabel];
        
        self.titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20.0, (kPadSettingConnectionCellHeight - 20.0)/2.0 - 11, kPadSettingConnectionCellWidth - 2 * 20.0 - 132.0, 20.0)];
        self.titleLabel1.backgroundColor = [UIColor clearColor];
        self.titleLabel1.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.titleLabel1.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel1.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLabel1];
        
        self.titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20.0, (kPadSettingConnectionCellHeight - 20.0)/2.0 + 11, kPadSettingConnectionCellWidth - 2 * 20.0 - 132.0, 20.0)];
        self.titleLabel2.backgroundColor = [UIColor clearColor];
        self.titleLabel2.textColor = COLOR(151, 151, 151, 1.0);
        self.titleLabel2.font = [UIFont systemFontOfSize:12.0];
        self.titleLabel2.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLabel2];
        
    }
    
    return self;
}

@end
