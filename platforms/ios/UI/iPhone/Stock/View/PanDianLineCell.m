//
//  PanDianLineCell.m
//  Boss
//
//  Created by lining on 15/9/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PanDianLineCell.h"
#import "UIImage+Resizable.h"

#define kMarginSize     12
#define kCellHeight     60
#define kLabelHeight    20
#define kPicWidth       48
#define kPicHeight      36

@implementation PanDianLineCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier width:width hasImgView:false];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width hasImgView:(BOOL)hasImgView
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = COLOR(249, 249, 249, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginSize, 0, width - 2*kMarginSize, 0.5)];
        self.lineImgView.backgroundColor = [UIColor clearColor];
        self.lineImgView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [self.contentView addSubview:self.lineImgView];
        
        CGFloat xCoord = kMarginSize;
        
        if (hasImgView) {
            self.backgroundColor = [UIColor whiteColor];
            self.picView = [[UIImageView alloc] initWithFrame:CGRectMake(xCoord, (kCellHeight - kPicHeight)/2.0, kPicWidth, kPicHeight)];
            self.picView.image = [UIImage imageNamed:@"project_item_default_48_36"];
            //        self.picView.layer.masksToBounds = YES;
            //        self.picView.layer.cornerRadius = kPicSize/2.0;
            [self.contentView addSubview:self.picView];
            self.lineImgView.frame = CGRectMake(0, 0, width, 0.5);
            xCoord += kPicWidth + kMarginSize;
        }
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, kCellHeight/2.0 - kLabelHeight-1, width - 2*kMarginSize, kLabelHeight)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.nameLabel];

        self.defaultCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, kCellHeight/2.0+1, width/2.0 - kMarginSize, kLabelHeight)];
        self.defaultCountLabel.backgroundColor = [UIColor clearColor];
        self.defaultCountLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        self.defaultCountLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.defaultCountLabel];
        
        UIImage *price_bg = [[UIImage imageNamed:@"pandian_input_bg.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] ;
        UILabel *countLabel = [[UILabel alloc] init];
        countLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        countLabel.font = [UIFont systemFontOfSize:12];
        countLabel.text = @"盘点数量: ";
        [countLabel sizeToFit];
        
        countLabel.frame = CGRectMake(width - countLabel.frame.size.width - kMarginSize - 2*price_bg.size.width, self.defaultCountLabel.frame.origin.y, countLabel.frame.size.width, kLabelHeight);
        [self.contentView addSubview:countLabel];
        
        
        self.countField = [[UITextField alloc] initWithFrame:CGRectMake(countLabel.frame.size.width + countLabel.frame.origin.x, kCellHeight/2.0 - 3, 2*price_bg.size.width, price_bg.size.height)];
        self.countField.borderStyle = UITextBorderStyleNone;
        self.countField.background = price_bg;
        self.countField.delegate = self;
        
        self.countField.font = [UIFont boldSystemFontOfSize:12];
        self.countField.textAlignment = NSTextAlignmentCenter;
        self.countField.keyboardType = UIKeyboardTypeNumberPad;
        self.countField.textColor = COLOR(104, 171, 245, 1);
        [self.contentView addSubview:self.countField];
        
        if (hasImgView) {
            self.defaultCountLabel.font = [UIFont boldSystemFontOfSize:12];
            countLabel.font = [UIFont boldSystemFontOfSize:12];
            self.countField.font = [UIFont boldSystemFontOfSize:12];
        }
        
        
    }
    
    return self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textField: %@",textField.text);
    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEdit:atIndexPath:)]) {
        [self.delegate textFieldDidEndEdit:textField.text atIndexPath:self.indexPath];
    }
}

@end
