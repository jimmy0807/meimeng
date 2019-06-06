//
//  PadProjectDetailSubRelatedCell.m
//  Boss
//
//  Created by XiaXianBing on 16/1/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadProjectDetailSubRelatedCell.h"
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"
#import "PadMaskViewConstant.h"

@implementation PadProjectDetailSubRelatedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat originY = 0.0;
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 0.5)];
        lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
        //[self.contentView addSubview:lineImageView];
        originY += 28.0;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:self.titleLabel];
        originY += 20.0 + 12.0;
        
        self.detailView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0)];
        self.detailView.backgroundColor = [UIColor clearColor];
        self.detailView.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
        self.detailView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.detailView];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 20.0, kPadDetailContentLabelWidth, self.detailView.frame.size.height)];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
        self.detailLabel.font = [UIFont systemFontOfSize:16.0];
        self.detailLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.detailLabel.numberOfLines = 0;
        [self.detailView addSubview:self.detailLabel];
        
        self.changeCountTextField = [[UITextField alloc] initWithFrame:CGRectMake(470, 75, 150, 30)];
        self.changeCountTextField.placeholder = @"请输入要修改的数量";
        self.changeCountTextField.font = [UIFont systemFontOfSize:15];
        self.changeCountTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.changeCountTextField.textAlignment = NSTextAlignmentCenter;
        self.changeCountTextField.hidden = YES;
        [self.contentView addSubview:self.changeCountTextField];
    }
    
    return self;
}

@end
