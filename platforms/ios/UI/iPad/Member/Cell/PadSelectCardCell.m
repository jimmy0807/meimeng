//
//  PadSelectCardCell.m
//  Boss
//
//  Created by XiaXianBing on 15/10/21.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadSelectCardCell.h"
#import "UIImage+Resizable.h"

@implementation PadSelectCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *selectImage = [UIImage imageNamed:@"pad_card_selected_n"];
        self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(24.0, (kPadSelectCardCellHeight - selectImage.size.height)/2.0, selectImage.size.width, selectImage.size.height)];
        self.selectImageView.backgroundColor = [UIColor clearColor];
        self.selectImageView.image = selectImage;
        [self.contentView addSubview:self.selectImageView];
        
        UIImage *stateImage = [UIImage imageNamed:@"pad_member_card_state"];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0 + 24.0 + 12.0, 0.0, kPadSelectCardCellWidth - 12.0 - stateImage.size.width, kPadSelectCardCellHeight)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        self.stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadSelectCardCellWidth - 12.0 - stateImage.size.width, (kPadSelectCardCellHeight - stateImage.size.height)/2.0, stateImage.size.width, stateImage.size.height)];
        self.stateImageView.backgroundColor = [UIColor clearColor];
        self.stateImageView.image = stateImage;
        [self.contentView addSubview:self.stateImageView];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, stateImage.size.width, stateImage.size.height)];
        self.stateLabel.backgroundColor = [UIColor clearColor];
        self.stateLabel.numberOfLines = 1;
        self.stateLabel.font = [UIFont boldSystemFontOfSize:13.0];
        self.stateLabel.textAlignment = NSTextAlignmentCenter;
        self.stateLabel.textColor = COLOR(168.0, 173.0, 173.0, 1.0);
        [self.stateImageView addSubview:self.stateLabel];
        
//        self.qrButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.qrButton.frame = CGRectMake(0,0,70,50);
//        [self.qrButton setImage:[UIImage imageNamed:@"pad_card_qrCode"] forState:UIControlStateNormal];
//        self.qrButton.center = self.stateImageView.center;
//        [self.qrButton addTarget:self action:@selector(didQrCodePressed:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:self.qrButton];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadSelectCardCellHeight, kPadSelectCardCellWidth, 1.0)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"pad_project_side_line"];
        [self.contentView addSubview:lineImageView];
    }
    
    return self;
}

- (void)didQrCodePressed:(id)sender
{
    [self.delegate didCardQrCodePressedAtIndexPath:self.indexPath];
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
