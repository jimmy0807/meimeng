//
//  OrderCell.m
//  Boss
//
//  Created by lining on 15/7/15.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "OrderCell.h"

#define kCellHeight         60
#define kExpandHeight       60
#define kMarginSize         20


@interface OrderCell ()

@property(nonatomic, strong) UIImageView *lineImgView;
@end

@implementation OrderCell

- (id)initWithWidth:(CGFloat)width type:(OrderCellType)type reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.type = type;
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_n"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_h"]];
        
        UIImage *arrowImage = nil;
        if (self.type == CellType_confirmed) {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            arrowImage = [UIImage imageNamed:@"order_rect_red.png"];
        }
        else if(self.type == CellType_approved)
        {
            arrowImage = [UIImage imageNamed:@"order_circle.png"];
        }
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, kCellHeight/2.0 - 20.0 + 2.0, width - 15 - arrowImage.size.width, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.tag = 101;
        self.titleLabel.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, kCellHeight/2.0 + 2.0, 250, 20.0)];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.font = [UIFont systemFontOfSize:13.0];
        self.detailLabel.tag = 102;
        self.detailLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [self.contentView addSubview:self.detailLabel];
        
        
        self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.detailLabel.frame.origin.x + self.detailLabel.frame.size.width + kMarginSize, kCellHeight/2.0 + 2.0, 100, 20.0)];
        self.amountLabel.backgroundColor = [UIColor clearColor];
        self.amountLabel.font = [UIFont systemFontOfSize:13.0];
        self.amountLabel.tag = 103;
        self.amountLabel.textColor = [UIColor redColor];
//        [self.contentView addSubview:self.amountLabel];
        
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 15 - arrowImage.size.width, (kCellHeight - arrowImage.size.height)/2.0, arrowImage.size.width, arrowImage.size.height)];
        self.arrowImageView.backgroundColor = [UIColor clearColor];
        self.arrowImageView.image = arrowImage;
        self.arrowImageView.tag = 105;
        
        [self.contentView addSubview:self.arrowImageView];
        
        
        self.rateLabel = [[UILabel alloc] initWithFrame:self.arrowImageView.frame];
        self.rateLabel.backgroundColor = [UIColor clearColor];
        self.rateLabel.font = [UIFont systemFontOfSize:12.0];
        self.rateLabel.tag = 103;
        self.rateLabel.textAlignment = NSTextAlignmentCenter;
      
        if (self.type == CellType_confirmed) {
            self.rateLabel.textColor = [UIColor redColor];
            self.rateLabel.text = @"待审核";
        }
        else if (self.type == CellType_approved)
        {
            self.rateLabel.textColor = COLOR(99, 199, 255, 1);
        }
        [self.contentView addSubview:self.rateLabel];
        
        self.lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kCellHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
        self.lineImgView.backgroundColor = [UIColor clearColor];
        self.lineImgView.tag = 106;
        self.lineImgView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        
        
        if (self.type == CellType_approved) {
            
            
        }
        [self.contentView addSubview:self.lineImgView];
    }
    return self;
}

+ (CGFloat)cellHeight:(OrderCellType)type
{
    return kCellHeight;
}

@end
