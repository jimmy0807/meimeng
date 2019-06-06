//
//  PadPaymentCell.m
//  Boss
//
//  Created by XiaXianBing on 15/10/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadPaymentCell.h"

@implementation PadPaymentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *checkImage = [UIImage imageNamed:@"pad_check_n"];
        self.checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(32.0, (kPadPaymentCellHeight - checkImage.size.height)/2.0, checkImage.size.width, checkImage.size.height)];
        self.checkImageView.backgroundColor = [UIColor clearColor];
        self.checkImageView.image = checkImage;
        [self.contentView addSubview:self.checkImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(32.0 + checkImage.size.width + 16.0, (kPadPaymentCellHeight - 20.0)/2.0, kPadPaymentCellWidth - 32.0 - checkImage.size.width - 16.0 - 96.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:17.0];
        self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(kPadPaymentCellWidth - 96.0, 0.0, 96.0, kPadPaymentCellHeight);
        self.cancelButton.backgroundColor = [UIColor clearColor];
        self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [self.cancelButton setTitle:LS(@"Cancel") forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:COLOR(96.0, 211.0, 212.0, 1.0) forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(didCancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.cancelButton];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadPaymentCellHeight - 0.5, kPadPaymentCellWidth, 0.5)];
        lineImageView.backgroundColor = COLOR(220.0, 224.0, 224.0, 1.0);
        [self.contentView addSubview:lineImageView];
    }
    
    return self;
}

- (void)didCancelButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadPaymentCellCancel:)])
    {
        [self.delegate didPadPaymentCellCancel:self];
    }
}

@end
