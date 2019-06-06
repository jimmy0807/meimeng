//
//  PadDetailInputCell.m
//  Boss
//
//  Created by XiaXianBing on 16/1/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadDetailInputCell.h"
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"
#import "PadMaskViewConstant.h"

@implementation PadDetailInputCell

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
        self.titleLabel.text = LS(@"PadTechnicianTitle");
        [self.contentView addSubview:self.titleLabel];
        originY += 20.0 + 12.0;
        
        self.background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0)];
        self.background.backgroundColor = [UIColor clearColor];
        self.background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
        self.background.userInteractionEnabled = YES;
        [self.contentView addSubview:self.background];
        self.inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(24.0, 0.0, self.background.frame.size.width - 2 * 24.0, self.background.frame.size.height)];
        self.inputTextField.backgroundColor = [UIColor clearColor];
        self.inputTextField.font = [UIFont systemFontOfSize:16.0];
        self.inputTextField.textAlignment = NSTextAlignmentCenter;
        self.inputTextField.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.inputTextField.placeholder = LS(@"PadTechnicianPlaceholder");
        self.inputTextField.enabled = NO;
        [self.background addSubview:self.inputTextField];
        
        UIImage *downImage = [UIImage imageNamed:@"pad_user_info_drop_down"];
        self.downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.background.frame.size.width - 24.0 - downImage.size.width, (self.background.frame.size.height - downImage.size.height)/2.0, downImage.size.width, downImage.size.height)];
        self.downImageView.backgroundColor = [UIColor clearColor];
        self.downImageView.image = downImage;
        [self.background addSubview:self.downImageView];
        
        self.contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.contentButton.backgroundColor = [UIColor clearColor];
        self.contentButton.frame = CGRectMake(0.0, 0.0, self.background.frame.size.width, self.background.frame.size.height);
        [self.contentButton addTarget:self action:@selector(didContentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.background addSubview:self.contentButton];
        
        UIImage *confirmImage = [UIImage imageNamed:@"pad_confirm_n"];
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmButton.backgroundColor = [UIColor clearColor];
        self.confirmButton.frame = CGRectMake(self.background.frame.size.width - 12.0 - confirmImage.size.width, (self.background.frame.size.height - confirmImage.size.height)/2.0, confirmImage.size.width, confirmImage.size.height);
        [self.confirmButton setBackgroundImage:confirmImage forState:UIControlStateNormal];
        self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
        [self.confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.confirmButton.alpha = 0.0;
        [self.background addSubview:self.confirmButton];
    }
    
    return self;
}

- (void)didContentButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didShowAndHidePickerView:)])
    {
        [self.delegate didShowAndHidePickerView:self];
    }
}

- (void)didConfirmButtonClick:(id)sender
{
    [self didContentButtonClick:nil];
}

@end
