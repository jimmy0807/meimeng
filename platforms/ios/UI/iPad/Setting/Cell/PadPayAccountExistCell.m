//
//  PadPayAccountExistCell.m
//  Boss
//
//  Created by XiaXianBing on 16/1/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadPayAccountExistCell.h"
#import "UIImage+Resizable.h"

@interface PadPayAccountExistCell ()

@property (nonatomic, strong) UIButton *accountButton;

@end

@implementation PadPayAccountExistCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.accountButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadPayAccountExistCellWidth, 60.0)];
        [self.accountButton setBackgroundImage:[[UIImage imageNamed:@"pad_setting_cell_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateNormal];
        [self.accountButton setBackgroundImage:[[UIImage imageNamed:@"pad_setting_cell_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateHighlighted];
        [self.accountButton setTitleColor:COLOR(136.0, 136.0, 136.0, 1.0) forState:UIControlStateNormal];
        self.accountButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:self.accountButton];
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 92.0, kPadPayAccountExistCellWidth, 60.0)];
        [deleteButton setBackgroundImage:[[UIImage imageNamed:@"pad_setting_cell_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateNormal];
        [deleteButton setBackgroundImage:[[UIImage imageNamed:@"pad_setting_cell_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateHighlighted];
        [deleteButton setTitleColor:COLOR(255.0, 110.0, 100.0, 1.0) forState:UIControlStateNormal];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [deleteButton setTitle:LS(@"PadPayAccountAccountDelete") forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(didDeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteButton];
    }
    
    return self;
}

- (void)setAccountName:(NSString *)accountName
{
    if (![_accountName isEqualToString:accountName])
    {
        _accountName = accountName;
        [self.accountButton setTitle:_accountName forState:UIControlStateNormal];
    }
}

- (void)didDeleteButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadPayAccountDeleteButtonClick:)])
    {
        [self.delegate didPadPayAccountDeleteButtonClick:self];
    }
}

@end
