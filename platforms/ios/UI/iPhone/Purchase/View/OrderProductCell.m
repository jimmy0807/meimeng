//
//  OrderProductTableViewCell.m
//  Boss
//
//  Created by lining on 15/6/19.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "OrderProductCell.h"

#define kCellHeight 90
#define kMarginSize 20

@implementation OrderProductCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width needAccessoryView:(BOOL)needAccessory
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *arrowImage = nil;
        if (needAccessory) {
            arrowImage  = [UIImage imageNamed:@"order_btn_selected_h.png"];
        }
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_n"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_h"]];
        
        CGFloat xCoord = kMarginSize;
        CGFloat yCoord = 12.0;
        UIImage *defaultImg = [UIImage imageNamed:@"project_item_default_48_36"];
        
        UIImageView *picImgView = [[UIImageView alloc] initWithFrame:CGRectMake(xCoord, (kCellHeight - defaultImg.size.height)/2.0, defaultImg.size.width, defaultImg.size.height)];
        
        xCoord += picImgView.frame.size.width + kMarginSize;
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord ,yCoord, 150, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.tag = 101;
        self.titleLabel.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        
        yCoord += self.titleLabel.frame.size.height;
        
        self.unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, yCoord, 150, 18.0)];
        self.unitLabel.backgroundColor = [UIColor clearColor];
        self.unitLabel.font = [UIFont systemFontOfSize:13.0];
        self.unitLabel.tag = 102;
        self.unitLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [self.contentView addSubview:self.unitLabel];
        
        
        yCoord += self.unitLabel.frame.size.height;
        
        self.noLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, yCoord, 150, 18.0)];
        self.noLabel.backgroundColor = [UIColor clearColor];
        self.noLabel.font = [UIFont systemFontOfSize:13.0];
        self.noLabel.tag = 103;
        self.noLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [self.contentView addSubview:self.noLabel];
        
        yCoord += self.noLabel.frame.size.height;
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, yCoord, 150, 18.0)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.font = [UIFont systemFontOfSize:13.0];
        self.dateLabel.tag = 104;
        self.dateLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [self.contentView addSubview:self.dateLabel];
        
        
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake((width - kMarginSize - arrowImage.size.width-100), (kCellHeight - 18)/2.0, 100, 18.0)];
        self.countLabel.backgroundColor = [UIColor clearColor];
        self.countLabel.font = [UIFont systemFontOfSize:13.0];
        self.countLabel.tag = 105;
        self.countLabel.textAlignment = NSTextAlignmentRight;
        self.countLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [self.contentView addSubview:self.countLabel];
        
        
        if (needAccessory) {
            UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - kMarginSize/2.0 - arrowImage.size.width, (kCellHeight - arrowImage.size.height)/2.0, arrowImage.size.width, arrowImage.size.height)];
            arrowImageView.backgroundColor = [UIColor clearColor];
            arrowImageView.image = arrowImage;
            [self.contentView addSubview:arrowImageView];
            
        }
        
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kCellHeight - 0.5, width, 0.5)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [self.contentView addSubview:lineImageView];
        
    }
    
    return self;
}

+(CGFloat)cellHeight
{
    return kCellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

}


@end
