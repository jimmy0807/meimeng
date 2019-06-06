//
//  PanDianLineHead.m
//  Boss
//
//  Created by lining on 15/9/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PanDianLineHead.h"

#define kMarginSize         12
#define kPicWidth           48
#define kPicHeight          36
#define kCellHeight         60


@interface PanDianLineHead ()
@property(nonatomic, strong) UIImageView *lineImgView;

@end
@implementation PanDianLineHead


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0, width, 0.5)];
        self.lineImgView.backgroundColor = [UIColor clearColor];
        self.lineImgView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [self.contentView addSubview:self.lineImgView];
        
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_n"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_h"]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *arrowImage = [UIImage imageNamed:@"purchase_down.png"];
        
        CGFloat xCoord = kMarginSize;
        
        self.picView = [[UIImageView alloc] initWithFrame:CGRectMake(xCoord, (kCellHeight - kPicHeight)/2.0, kPicWidth, kPicHeight)];
        self.picView.image = [UIImage imageNamed:@"project_item_default_48_36"];
        //        self.picView.layer.masksToBounds = YES;
        //        self.picView.layer.cornerRadius = kPicSize/2.0;
        [self.contentView addSubview:self.picView];
        
        
        xCoord += kPicWidth + kMarginSize;
        CGFloat labelWidth = width - xCoord - arrowImage.size.width - 20;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, (kCellHeight - 20.0)/2.0, labelWidth, 20.0)];
        self.nameLabel.highlighted = NO;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:15.0];
        
        self.nameLabel.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
        [self.contentView addSubview:self.nameLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, kCellHeight/2.0 + 2.0, self.nameLabel.frame.size.width, 20.0)];
        self.detailLabel.highlighted = NO;
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.font = [UIFont systemFontOfSize:12.0];
        self.detailLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.detailLabel];
        
        xCoord += self.nameLabel.frame.size.width;
        
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 10 - arrowImage.size.width, (kCellHeight - arrowImage.size.height)/2.0, arrowImage.size.width, arrowImage.size.height)];
        self.arrowImageView.backgroundColor = [UIColor clearColor];
        self.arrowImageView.image = arrowImage;
        self.arrowImageView.highlightedImage = [UIImage imageNamed:@"purchase_up.png"];
        [self.contentView addSubview:self.arrowImageView];
        
        self.bottomLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kCellHeight - 0.5, width, 0.5)];
        self.bottomLineImgView.backgroundColor = [UIColor clearColor];
        self.bottomLineImgView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
//        [self.contentView addSubview:self.bottomLineImgView];
        

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
