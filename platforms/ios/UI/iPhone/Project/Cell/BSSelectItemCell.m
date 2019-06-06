//
//  BSSelectItemCell.m
//  Boss
//
//  Created by XiaXianBing on 15/6/1.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSSelectItemCell.h"
#import "UIImage+Resizable.h"

#define kBSEditCellMargin       12.0
#define kBSItemCellImageWidth   48.0
#define kBSItemCellImageHeight  36.0
#define kBSTextContentMargin    8.0
#define kBSValueTextFieldWidth  44.0
#define kBSValueTextFieldHeight 28.0


@interface BSSelectItemCell ()
@property(nonatomic, strong) UIImageView *lineImageView;
@end


@implementation BSSelectItemCell

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
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bs_common_cell_h"]];
        self.selectedBackgroundView.autoresizingMask = 0xff;
        
        UIImage *selectImage = [UIImage imageNamed:@"login_remeberPw_n"];
        self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kBSEditCellMargin, (kBSSelectItemCellHeight - selectImage.size.height)/2.0, selectImage.size.width, selectImage.size.height)];
        self.selectImageView.backgroundColor = [UIColor clearColor];
        self.selectImageView.image = [UIImage imageNamed:@"login_remeberPw_n"];
        self.selectImageView.highlightedImage = [UIImage imageNamed:@"login_remeberPw_h"];
        [self.contentView addSubview:self.selectImageView];
        
        self.itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kBSEditCellMargin + selectImage.size.width + kBSTextContentMargin, (kBSSelectItemCellHeight - kBSItemCellImageHeight)/2.0, kBSItemCellImageWidth, kBSItemCellImageHeight)];
        self.itemImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.itemImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBSEditCellMargin + selectImage.size.width + kBSTextContentMargin + kBSItemCellImageWidth + kBSTextContentMargin, kBSSelectItemCellHeight/2.0 - 20.0 + 2.0, IC_SCREEN_WIDTH - 2*kBSEditCellMargin - 2*kBSTextContentMargin - selectImage.size.width - kBSItemCellImageWidth - kBSValueTextFieldWidth, 20.0)];
        self.titleLabel.highlighted = NO;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBSEditCellMargin + selectImage.size.width + kBSTextContentMargin + kBSItemCellImageWidth + kBSTextContentMargin, kBSSelectItemCellHeight/2.0 + 2.0, IC_SCREEN_WIDTH - 2*kBSEditCellMargin - 2*kBSTextContentMargin - selectImage.size.width - kBSItemCellImageWidth - kBSValueTextFieldWidth, 20.0)];
        self.detailLabel.highlighted = NO;
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.font = [UIFont systemFontOfSize:13.0];
        self.detailLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [self.contentView addSubview:self.detailLabel];
        
        self.valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kBSEditCellMargin - kBSValueTextFieldWidth, (kBSSelectItemCellHeight - kBSValueTextFieldHeight)/2.0, kBSValueTextFieldWidth, kBSValueTextFieldHeight)];
        self.valueTextField.background = [[UIImage imageNamed:@"pandian_input_bg"] imageResizableWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        self.valueTextField.textAlignment = NSTextAlignmentCenter;
        self.valueTextField.font = [UIFont systemFontOfSize:14.0];
        self.valueTextField.textColor = COLOR(54.0, 172.0, 245.0, 1.0);
        self.valueTextField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:self.valueTextField];
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


@end
