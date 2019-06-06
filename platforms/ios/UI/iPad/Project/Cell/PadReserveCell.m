//
//  PadReserveCell.m
//  Boss
//
//  Created by XiaXianBing on 15/12/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadReserveCell.h"

@implementation PadReserveCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat originX = 24.0;
        UIImage *selectImage = [UIImage imageNamed:@"pad_card_selected_n"];
        self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, (kPadReserveCellHeight - selectImage.size.height)/2.0, selectImage.size.width, selectImage.size.height)];
        self.selectImageView.backgroundColor = [UIColor clearColor];
        self.selectImageView.image = selectImage;
        [self.contentView addSubview:self.selectImageView];
        originX += selectImage.size.width + 32.0;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, kPadReserveCellHeight/2.0 - 20.0, 132.0, 20.0)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:16.0];
        self.nameLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.nameLabel];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, kPadReserveCellHeight/2.0, 132.0, 20.0)];
        self.phoneLabel.backgroundColor = [UIColor clearColor];
        self.phoneLabel.font = [UIFont systemFontOfSize:14.0];
        self.phoneLabel.textColor = COLOR(128.0, 128.0, 128.0, 1.0);
        [self.contentView addSubview:self.phoneLabel];
        originX += 132.0 + 32.0;
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, kPadReserveCellHeight/2.0 - 20.0, 160.0, 20.0)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font = [UIFont systemFontOfSize:16.0];
        self.timeLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.timeLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, kPadReserveCellHeight/2.0, 160.0, 20.0)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.font = [UIFont systemFontOfSize:14.0];
        self.dateLabel.textColor = COLOR(128.0, 128.0, 128.0, 1.0);
        [self.contentView addSubview:self.dateLabel];
        originX += 160.0 + 32.0;
        
        self.technicianLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, kPadReserveCellHeight/2.0 - 20.0, kPadReserveCellWidth - originX - 24.0, 20.0)];
        self.technicianLabel.backgroundColor = [UIColor clearColor];
        self.technicianLabel.font = [UIFont systemFontOfSize:16.0];
        self.technicianLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.technicianLabel];
        
        self.itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, kPadReserveCellHeight/2.0, kPadReserveCellWidth - originX - 24.0, 20.0)];
        self.itemLabel.backgroundColor = [UIColor clearColor];
        self.itemLabel.font = [UIFont systemFontOfSize:14.0];
        self.itemLabel.textColor = COLOR(128.0, 128.0, 128.0, 1.0);
        [self.contentView addSubview:self.itemLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadReserveCellHeight - 1.0, kPadReserveCellWidth, 1.0)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"pad_reserve_cell_line"];
        [self.contentView addSubview:lineImageView];
    }
    
    return self;
}

- (void)isSelectImageViewSelected:(BOOL)isSelect
{
    if (isSelect)
    {
        self.selectImageView.image= [UIImage imageNamed:@"pad_card_selected_h"];
    }
    else
    {
        self.selectImageView.image= [UIImage imageNamed:@"pad_card_selected_n"];
    }
}


@end
