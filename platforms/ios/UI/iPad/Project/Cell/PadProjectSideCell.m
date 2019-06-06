//
//  PadProjectSideCell.m
//  Boss
//
//  Created by XiaXianBing on 15/10/9.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectSideCell.h"
#import "PadProjectConstant.h"

@interface PadProjectSideCell ()

@end

@implementation PadProjectSideCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        UIImageView *normalImageView = [[UIImageView alloc] init];
        normalImageView.backgroundColor = [UIColor whiteColor];
        self.backgroundView = normalImageView;
        UIImageView *selectedImageView = [[UIImageView alloc] init];
        selectedImageView.backgroundColor = COLOR(233.0, 237.0, 237.0, 1.0);
        self.selectedBackgroundView = selectedImageView;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0, 8.0, kPadProjectSideCellWidth - 24.0 - 24.0 - 48.0, 44.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.font = IOS7FONT(15.0);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.contentMode = UIViewContentModeBottom;
        self.titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadProjectSideCellWidth - 24.0 - 48.0, 20.0, 48.0, 24.0)];
        self.numberLabel.backgroundColor = [UIColor clearColor];
        self.numberLabel.font = IOS7FONT(14.0);
        self.numberLabel.textAlignment = NSTextAlignmentRight;
        self.numberLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.numberLabel];
        
        self.symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0, kPadProjectSideCellHeight/2.0 + 8.0, 12.0, 12.0)];
        self.symbolLabel.backgroundColor = [UIColor clearColor];
        self.symbolLabel.font = IOS7FONT(14.0);
        self.symbolLabel.textAlignment = NSTextAlignmentLeft;
        self.symbolLabel.text = LS(@"PadMoneySymbol");
        self.symbolLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.symbolLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0 + 10.0, kPadProjectSideCellHeight/2.0 + 4.0, kPadProjectSideCellWidth - 24.0 - 24.0 - 10.0, 24.0)];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.font = IOS7FONT(20.0);
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        self.priceLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.priceLabel];
        
        self.useLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadProjectSideCellWidth - 24.0 - 60.0, 46, 60.0, 24.0)];
        self.useLabel.backgroundColor = [UIColor clearColor];
        self.useLabel.font = IOS7FONT(13.0);
        self.useLabel.textAlignment = NSTextAlignmentRight;
        self.useLabel.textColor = COLOR(82, 203, 201, 1.0);
        [self.contentView addSubview:self.useLabel];
        
        self.buweiLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0, 75, kPadProjectSideCellWidth - 24.0 - 24.0, 40)];
        self.buweiLabel.backgroundColor = [UIColor clearColor];
        self.buweiLabel.numberOfLines = 2;
        self.buweiLabel.font = IOS7FONT(11.0);
        self.buweiLabel.textAlignment = NSTextAlignmentLeft;
        self.buweiLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.buweiLabel];
        
        self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadProjectSideCellHeight - 1.0, kPadProjectSideCellWidth, 1.0)];
        self.lineImageView.backgroundColor = [UIColor clearColor];
        self.lineImageView.image = [UIImage imageNamed:@"pad_project_side_line"];
        [self.contentView addSubview:self.lineImageView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.lineImageView != nil)
    {
        self.lineImageView.frame = CGRectMake(0.0, self.contentView.frame.size.height - 1.0, kPadProjectSideCellWidth, 1.0);
    }
}

@end
