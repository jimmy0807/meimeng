//
//  PanDianCell.m
//  Boss
//
//  Created by lining on 15/9/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PanDianCell.h"

#define kCellHeight         80
#define kMarginSize         20
#define kLabelHeight        20

@interface PanDianCell ()

@property(nonatomic, strong) UIImageView *lineImgView;
@end

@implementation PanDianCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_n"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_h"]];
        
        UIImage *arrowImage = nil;
        arrowImage = [UIImage imageNamed:@"project_item_arrow.png"];
        
        CGFloat yCoord = 10;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, yCoord, width - 15 - arrowImage.size.width, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.tag = 101;
        self.titleLabel.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        yCoord += kLabelHeight + 2;
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, yCoord, self.titleLabel.frame.size.width, 20.0)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.font = [UIFont systemFontOfSize:13.0];
        self.dateLabel.tag = 103;
        //        self.amountLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [self.contentView addSubview:self.dateLabel];
        
        
        yCoord += kLabelHeight;
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, yCoord,self.titleLabel.frame.size.width, 20.0)];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.font = [UIFont systemFontOfSize:13.0];
        self.detailLabel.tag = 102;
        self.detailLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [self.contentView addSubview:self.detailLabel];
        
        
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 15 - arrowImage.size.width, (kCellHeight - arrowImage.size.height)/2.0, arrowImage.size.width, arrowImage.size.height)];
        self.arrowImageView.backgroundColor = [UIColor clearColor];
        self.arrowImageView.image = arrowImage;
        self.arrowImageView.tag = 105;
        
        [self.contentView addSubview:self.arrowImageView];
        

        
        self.lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kCellHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
        self.lineImgView.backgroundColor = [UIColor clearColor];
        self.lineImgView.tag = 106;
        self.lineImgView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        
        [self.contentView addSubview:self.lineImgView];

    }
    
    return self;
}

+ (CGFloat)cellHeight
{
    return kCellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
