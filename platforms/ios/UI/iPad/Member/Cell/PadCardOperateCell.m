//
//  PadCardOperateCell.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadCardOperateCell.h"
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"
#import "PadMaskViewConstant.h"

@implementation PadCardOperateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat originY = 28.0;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:self.titleLabel];
        originY += 20.0 + 12.0;
        
        self.contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.contentButton.backgroundColor = [UIColor clearColor];
        self.contentButton.frame = CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0);
        [self.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateNormal];
        [self.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)] forState:UIControlStateHighlighted];
        [self.contentButton addTarget:self action:@selector(didContentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.contentButton];
        
        self.contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 0.0, kPadMaskViewContentWidth - 2 * 20.0, 60.0)];
        self.contentTextField.backgroundColor = [UIColor clearColor];
        self.contentTextField.font = [UIFont systemFontOfSize:16.0];
        self.contentTextField.clearsOnBeginEditing = TRUE;
        self.contentTextField.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentButton addSubview:self.contentTextField];
        
        UIImage *downImage = [UIImage imageNamed:@"pad_user_info_drop_down"];
        self.downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentButton.frame.size.width - 24.0 - downImage.size.width, (self.contentButton.frame.size.height - downImage.size.height)/2.0, downImage.size.width, downImage.size.height)];
        self.downImageView.backgroundColor = [UIColor clearColor];
        self.downImageView.image = downImage;
        self.downImageView.alpha = 0.0;
        [self.contentButton addSubview:self.downImageView];
        
        UIImage *confirmImage = [UIImage imageNamed:@"pad_confirm_n"];
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmButton.backgroundColor = [UIColor clearColor];
        self.confirmButton.frame = CGRectMake(self.contentButton.frame.size.width - 12.0 - confirmImage.size.width, (self.contentButton.frame.size.height - confirmImage.size.height)/2.0, confirmImage.size.width, confirmImage.size.height);
        [self.confirmButton setBackgroundImage:confirmImage forState:UIControlStateNormal];
        self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
        [self.confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.confirmButton.alpha = 0.0;
        [self.contentButton addSubview:self.confirmButton];
    }
    
    return self;
}

- (void)didContentButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didContentButtonClick:)])
    {
        [self.delegate didContentButtonClick:self];
    }
}

- (void)didConfirmButtonClick:(id)sender
{
    [self didContentButtonClick:nil];
}

@end
