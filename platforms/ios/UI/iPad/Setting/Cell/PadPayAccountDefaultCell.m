//
//  PadPayAccountDefaultCell.m
//  Boss
//
//  Created by XiaXianBing on 16/1/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadPayAccountDefaultCell.h"
#import "UIImage+Resizable.h"

@implementation PadPayAccountDefaultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadPayAccountDefaultCellWidth, kPadPayAccountDefaultCellHeight)];
        [addButton setBackgroundImage:[[UIImage imageNamed:@"pad_setting_cell_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateNormal];
        [addButton setBackgroundImage:[[UIImage imageNamed:@"pad_setting_cell_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateHighlighted];
        [addButton setTitleColor:COLOR(136.0, 136.0, 136.0, 1.0) forState:UIControlStateNormal];
        addButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [addButton setTitle:LS(@"PadPayAccountAddAccount") forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(didAddButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addButton];
    }
    
    return self;
}

- (void)didAddButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadPayAccountAddButtonClick:)])
    {
        [self.delegate didPadPayAccountAddButtonClick:self];
    }
}

@end
