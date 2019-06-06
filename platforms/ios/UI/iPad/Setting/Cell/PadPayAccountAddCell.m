//
//  PadPayAccountAddCell.m
//  Boss
//
//  Created by XiaXianBing on 16/1/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadPayAccountAddCell.h"
#import "UIImage+Resizable.h"

@implementation PadPayAccountAddCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadPayAccountAddCellWidth, 120.0)];
        background.backgroundColor = [UIColor clearColor];
        background.image = [[UIImage imageNamed:@"pad_setting_cell_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
        background.userInteractionEnabled = YES;
        [self.contentView addSubview:background];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, (60.0 - 20.0)/2.0, 48.0, 20.0)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        nameLabel.font = [UIFont systemFontOfSize:16.0];
        nameLabel.text = LS(@"PadPayAccountAccountName");
        [background addSubview:nameLabel];
        
        self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0 + 48.0, 0.0, kPadPayAccountAddCellWidth - 2 * 20.0 - 48.0, 60.0)];
        self.usernameTextField.backgroundColor = [UIColor clearColor];
        self.usernameTextField.font = [UIFont systemFontOfSize:16.0];
        self.usernameTextField.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LS(@"PadPayAccountNamePlaceholder") attributes:@{NSForegroundColorAttributeName:COLOR(136.0, 136.0, 136.0, 1.0)}];
        self.usernameTextField.textAlignment = NSTextAlignmentRight;
        self.usernameTextField.tag = 101;
        self.usernameTextField.delegate = self;
        [background addSubview:self.usernameTextField];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 59.5, kPadPayAccountAddCellWidth, 1.0)];
        lineImageView.backgroundColor = COLOR(220.0, 224.0, 224.0, 1.0);
        [background addSubview:lineImageView];
        
        UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60 + (60.0 - 20.0)/2.0, 48.0, 20.0)];
        passwordLabel.backgroundColor = [UIColor clearColor];
        passwordLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        passwordLabel.font = [UIFont systemFontOfSize:16.0];
        passwordLabel.text = LS(@"PadPayAccountAccountPassword");
        [background addSubview:passwordLabel];
        
        self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0 + 48.0, 60.0, kPadPayAccountAddCellWidth - 2 * 20.0 - 48.0, 60.0)];
        self.passwordTextField.backgroundColor = [UIColor clearColor];
        self.passwordTextField.font = [UIFont systemFontOfSize:16.0];
        self.passwordTextField.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LS(@"PadPayAccountPasswordPlaceholder") attributes:@{NSForegroundColorAttributeName:COLOR(136.0, 136.0, 136.0, 1.0)}];
        self.passwordTextField.secureTextEntry = YES;
        self.passwordTextField.textAlignment = NSTextAlignmentRight;
        self.passwordTextField.tag = 102;
        self.passwordTextField.delegate = self;
        [background addSubview:self.passwordTextField];
        
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 152.0, kPadPayAccountAddCellWidth, 60.0)];
        [addButton setBackgroundImage:[[UIImage imageNamed:@"pad_confirm_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateNormal];
        [addButton setBackgroundImage:[[UIImage imageNamed:@"pad_confirm_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateHighlighted];
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [addButton setTitle:LS(@"PadPayAccountAccountAdd") forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(didAddButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addButton];
    }
    
    return self;
}

- (void)didAddButtonClick:(id)sender
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    if (self.usernameTextField.text.length == 0 || self.passwordTextField.text.length == 0)
    {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadPayAccountConfirmButtonClick:)])
    {
        [self.delegate didPadPayAccountConfirmButtonClick:self];
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(padPayAccountAddCell:didTextFieldEndEdit:)])
    {
        [self.delegate padPayAccountAddCell:self didTextFieldEndEdit:textField];
    }
}

@end
