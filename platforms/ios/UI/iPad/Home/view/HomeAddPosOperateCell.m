//
//  HomeAddPosOperateCell.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-21.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "HomeAddPosOperateCell.h"
#import "UIImage+Resizable.h"

@interface HomeAddPosOperateCell ()


@end

@implementation HomeAddPosOperateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *backgroundImage = [UIImage imageNamed:@"Home_currentPos_cellBg_N"];
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(150.0, 0.0, IC_SCREEN_WIDTH - 2 * 150.0, 78.0)];
        background.backgroundColor = [UIColor clearColor];
        background.image = [backgroundImage imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 80.0, 8.0, 20.0)];
        [self.contentView addSubview:background];
        
        UIImage *addImage = [UIImage imageNamed:@"pad_home_pos_operate_add"];
        UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1.5, 0.0, addImage.size.width, addImage.size.height)];
        addImageView.backgroundColor = [UIColor clearColor];
        addImageView.image = addImage;
        [background addSubview:addImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(addImageView.frame.origin.x + addImageView.frame.size.width + 24.0 + 4.0, (75.0 - 20.0)/2.0, background.frame.size.width - addImageView.frame.size.width - 28.0 - 28.0, 20.0)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 1;
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        titleLabel.text = LS(@"PadAddTakeoutPosOperate");
        [background addSubview:titleLabel];
    }
    
    return self;
}

@end
