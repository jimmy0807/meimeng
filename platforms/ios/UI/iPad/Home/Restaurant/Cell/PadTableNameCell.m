//
//  PadTableNameCell.m
//  Boss
//
//  Created by XiaXianBing on 16-2-25.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadTableNameCell.h"
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"

@implementation PadTableNameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat originY = 28.0;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, originY, kPadTableNameCellWidth - 2 * 20.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:self.titleLabel];
        originY += 20.0 + 12.0;
        
        self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, originY, kPadTableNameCellWidth - 2 * 20.0, 60.0)];
        self.nameTextField.backgroundColor = [UIColor clearColor];
        self.nameTextField.background = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
        self.nameTextField.font = [UIFont systemFontOfSize:16.0];
        self.nameTextField.textAlignment = NSTextAlignmentLeft;
        self.nameTextField.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 60.0)];
        leftView.backgroundColor = [UIColor clearColor];
        leftView.userInteractionEnabled = NO;
        self.nameTextField.leftView = leftView;
        self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 60.0)];
        rightView.backgroundColor = [UIColor clearColor];
        rightView.userInteractionEnabled = NO;
        self.nameTextField.rightView = rightView;
        self.nameTextField.rightViewMode = UITextFieldViewModeAlways;
        self.nameTextField.delegate = self;
        [self.contentView addSubview:self.nameTextField];
    }
    
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate didTableNameChanged:textField.text];
}

@end
