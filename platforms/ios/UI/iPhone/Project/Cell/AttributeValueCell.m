//
//  AttributeValueCell.m
//  Boss
//
//  Created by XiaXianBing on 15/9/2.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "AttributeValueCell.h"
#import "UIImage+Resizable.h"

#define kAttributeValueCellHeight       44.0
#define kAttributeValueCellMargin       16.0
#define kAttributeValueContentWidth     56.0
#define kAttributeValueContentHeight    32.0

@interface AttributeValueCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *lineImageView;

@end

@implementation AttributeValueCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.autoresizingMask = 0xff;
        self.contentView.autoresizingMask = 0xff;
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bs_common_cell_n"]];
        self.backgroundView.autoresizingMask = 0xff;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.0, (kAttributeValueCellHeight - kAttributeValueContentHeight)/2.0, kAttributeValueContentWidth, kAttributeValueContentHeight)];
        self.frameImageView.image = [[UIImage imageNamed:@"attribute_value_label"] imageResizableWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
        self.frameImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:self.frameImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 0.0, self.frameImageView.frame.size.width - 2 * 8.0, self.frameImageView.frame.size.height)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = COLOR(251.0, 123.0, 120.0, 1.0);
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.frameImageView addSubview:self.titleLabel];
        
        UIImage *arrowImage = [UIImage imageNamed:@"bs_common_arrow"];
        self.contentField = [[UITextField alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - 16.0 - arrowImage.size.width - 4.0 - 96.0, 0.0, 96.0, kAttributeValueCellHeight)];
        self.contentField.backgroundColor = [UIColor clearColor];
        self.contentField.placeholder = LS(@"SetAttributePrice");
        self.contentField.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentField setValue:COLOR(136.0, 136.0, 136.0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        self.contentField.font = [UIFont boldSystemFontOfSize:14.0];
        self.contentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.contentField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.contentField.returnKeyType = UIReturnKeyDone;
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 16.0, self.contentField.frame.size.height)];
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.text = @"¥";
        leftLabel.font = [UIFont boldSystemFontOfSize:16.0];
        leftLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        leftLabel.textAlignment = NSTextAlignmentLeft;
        self.contentField.leftView = leftLabel;
        self.contentField.leftViewMode = UITextFieldViewModeAlways;
        self.contentField.delegate = self;
        self.contentField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:self.contentField];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - 16.0 - arrowImage.size.width, (kAttributeValueCellHeight - arrowImage.size.height)/2.0, arrowImage.size.width, arrowImage.size.height)];
        arrowImageView.backgroundColor = [UIColor clearColor];
        arrowImageView.image = [UIImage imageNamed:@"bs_common_arrow"];
        arrowImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:arrowImageView];
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ( self.lineImageView == nil )
    {
        self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.contentView.frame.size.height - 0.5, IC_SCREEN_WIDTH, 0.5)];
        self.lineImageView.backgroundColor = [UIColor clearColor];
        self.lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [self.contentView addSubview:self.lineImageView];
    }
}

- (void)setTitleLabelText:(NSString *)title
{
    self.titleLabel.text = title;
    CGSize minSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(IC_SCREEN_WIDTH - 16.0 - self.contentField.frame.origin.x - 2 * 8.0, self.titleLabel.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
    if (minSize.width < kAttributeValueContentWidth - 2 * 8.0)
    {
        self.frameImageView.frame = CGRectMake(self.frameImageView.frame.origin.x, self.frameImageView.frame.origin.y, kAttributeValueContentWidth, kAttributeValueContentHeight);
        self.titleLabel.frame = CGRectMake(8.0, 0.0, kAttributeValueContentWidth - 2 * 8.0, kAttributeValueContentHeight);
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.text.floatValue == 0.0)
    {
        textField.text = @"";
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didContentFieldEndEdit:)])
    {
        [self.delegate didContentFieldEndEdit:self];
    }
}


@end

