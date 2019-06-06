//
//  PadProjectDetailAppointmentCell.m
//  Boss
//
//  Created by XiaXianBing on 16/1/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadProjectDetailAppointmentCell.h"
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"
#import "PadMaskViewConstant.h"

@implementation PadProjectDetailAppointmentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, 28.0, kPadMaskViewContentWidth, 60.0)];
        self.background.backgroundColor = [UIColor clearColor];
        self.background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
        self.background.userInteractionEnabled = YES;
        [self.contentView addSubview:self.background];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, 120.0, self.background.frame.size.height)];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
        self.detailLabel.font = [UIFont systemFontOfSize:16.0];
        self.detailLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.detailLabel.text = [NSString stringWithFormat:LS(@"PadAppointmentTitle")];
        [self.background addSubview:self.detailLabel];
        
        UIImage *confirmImage = [UIImage imageNamed:@"pad_confirm_n"];
        self.timeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0 + 120.0, 0.0, self.background.frame.size.width - 20.0 - 2 * 12.0 - 120.0 - confirmImage.size.width, self.background.frame.size.height)];
        self.timeTextField.backgroundColor = [UIColor clearColor];
        self.timeTextField.font = [UIFont systemFontOfSize:16.0];
        self.timeTextField.textAlignment = NSTextAlignmentRight;
        self.timeTextField.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.timeTextField.enabled = NO;
        self.timeTextField.userInteractionEnabled = NO;
        [self.background addSubview:self.timeTextField];
        
        UIImage *downImage = [UIImage imageNamed:@"pad_user_info_drop_down"];
        UIImageView *downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.background.frame.size.width - 24.0 - downImage.size.width, (self.background.frame.size.height - downImage.size.height)/2.0, downImage.size.width, downImage.size.height)];
        downImageView.backgroundColor = [UIColor clearColor];
        downImageView.image = downImage;
        [self.background addSubview:downImageView];
        UIButton *appointmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        appointmentButton.backgroundColor = [UIColor clearColor];
        appointmentButton.frame = CGRectMake(0.0, 0.0, self.background.frame.size.width, self.background.frame.size.height);
        [appointmentButton addTarget:self action:@selector(didAppointmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.background addSubview:appointmentButton];
        
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

- (void)didAppointmentButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didShowAndHideAppointmentPickerView:)])
    {
        [self.delegate didShowAndHideAppointmentPickerView:self];
    }
}

- (void)didConfirmButtonClick:(id)sender
{
    [self didAppointmentButtonClick:nil];
}

@end
