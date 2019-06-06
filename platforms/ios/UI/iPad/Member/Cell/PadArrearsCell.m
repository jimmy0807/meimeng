//
//  PadArrearsCell.m
//  Boss
//
//  Created by XiaXianBing on 2016-4-20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadArrearsCell.h"

@implementation PadArrearsCell

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
        selectedImageView.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
        self.selectedBackgroundView = selectedImageView;
        
        UIImage *selectImage = [UIImage imageNamed:@"pad_card_selected_n"];
        self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectedButton.backgroundColor = [UIColor clearColor];
        self.selectedButton.frame = CGRectMake(0.0, 0.0, selectImage.size.width + 2 * 24.0, kPadArrearsCellHeight);
        [self.selectedButton setImage:selectImage forState:UIControlStateNormal];
        [self.selectedButton setImage:[UIImage imageNamed:@"pad_card_selected_h"] forState:UIControlStateHighlighted];
        [self.selectedButton addTarget:self action:@selector(didSelectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectedButton];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0 + selectImage.size.width + 24.0, kPadArrearsCellHeight/2.0 - 20.0, kPadArrearsCellWidth - 2 * 24.0 - selectImage.size.width - 32.0 - 64.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.font = IOS7FONT(15.0);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadArrearsCellWidth - 24.0 - 72.0, kPadArrearsCellHeight/2.0 - 20.0, 72.0, 20.0)];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.numberOfLines = 1;
        self.priceLabel.font = IOS7FONT(15.0);
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.priceLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.priceLabel];
        
        self.operateLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0 + selectImage.size.width + 24.0, kPadArrearsCellHeight/2.0, kPadArrearsCellWidth - 2 * 24.0 - selectImage.size.width - 32.0 - 72.0, 20.0)];
        self.operateLabel.backgroundColor = [UIColor clearColor];
        self.operateLabel.numberOfLines = 1;
        self.operateLabel.font = IOS7FONT(13.0);
        self.operateLabel.textAlignment = NSTextAlignmentLeft;
        self.operateLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.operateLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadArrearsCellWidth - 24.0 - 72.0, kPadArrearsCellHeight/2.0, 72.0, 20.0)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.numberOfLines = 1;
        self.dateLabel.font = IOS7FONT(13.0);
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.dateLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadArrearsCellHeight - 0.5, kPadArrearsCellWidth, 0.5)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"pad_project_side_line"];
        [self.contentView addSubview:lineImageView];
    }
    
    return self;
}

- (void)isArrearsSelected:(BOOL)isSelect
{
    if (isSelect)
    {
        [self.selectedButton setImage:[UIImage imageNamed:@"pad_card_selected_h"] forState:UIControlStateNormal];
        [self.selectedButton setImage:[UIImage imageNamed:@"pad_card_selected_h"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.selectedButton setImage:[UIImage imageNamed:@"pad_card_selected_n"] forState:UIControlStateNormal];
        [self.selectedButton setImage:[UIImage imageNamed:@"pad_card_selected_n"] forState:UIControlStateHighlighted];
    }
}


#pragma mark -
#pragma mark Required Methods

- (void)didSelectedButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadArrearsSelected:)])
    {
        [self.delegate didPadArrearsSelected:self];
    }
}

@end
