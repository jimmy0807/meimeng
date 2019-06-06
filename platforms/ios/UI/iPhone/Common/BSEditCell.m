//
//  BSEditCell.m
//  Boss
//
//  Created by XiaXianBing on 15/6/1.
//  Copyright (c) 2014年 BORN. All rights reserved.
//

#import "BSEditCell.h"

#define kBSEditCellHeight           44.0
#define kBSEditCellMargin           16.0
#define kBSEditCellArrowSize        16.0
#define kBSEditCellTitleWidth       150.0
#define kBSEditCellContentWidth   (IC_SCREEN_WIDTH - 2*kBSEditCellMargin - kBSEditCellTitleWidth - kBSEditCellArrowSize - 4.0)


@interface BSEditCell ()
@property (nonatomic, strong) UIImageView *lineImageView;
@end

@implementation BSEditCell

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
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBSEditCellMargin, 0.0, kBSEditCellTitleWidth, kBSEditCellHeight)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.titleLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.titleLabel];
        
        self.contentField = [[UITextField alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kBSEditCellMargin - kBSEditCellArrowSize - kBSEditCellContentWidth - 4.0, 0.0, kBSEditCellContentWidth, kBSEditCellHeight)];
        self.contentField.backgroundColor = [UIColor clearColor];
        self.contentField.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentField setValue:COLOR(136.0, 136.0, 136.0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        self.contentField.textAlignment = NSTextAlignmentRight;
        self.contentField.font = [UIFont boldSystemFontOfSize:13.0];
        self.contentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.contentField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.contentField.enabled = false;
        self.contentField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.contentField.returnKeyType = UIReturnKeyDone;
        //self.contentField.clearsOnBeginEditing = YES;
        self.contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.contentField.spellCheckingType = UITextSpellCheckingTypeNo;
        self.contentField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        [self.contentView addSubview:self.contentField];
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kBSEditCellMargin - kBSEditCellArrowSize, (kBSEditCellHeight - kBSEditCellArrowSize)/2.0, kBSEditCellArrowSize, kBSEditCellArrowSize)];
        self.arrowImageView.backgroundColor = [UIColor clearColor];
        self.arrowImageView.image = [UIImage imageNamed:@"bs_common_arrow"];
        self.arrowImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:self.arrowImageView];
        
        UIImage *scanImage = [UIImage imageNamed:@"navi_scan_h"];
        self.scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.scanButton.frame = CGRectMake(self.arrowImageView.frame.origin.x - 4.0, (kBSEditCellHeight - scanImage.size.height)/2.0, scanImage.size.width, scanImage.size.height);
        self.scanButton.backgroundColor = [UIColor clearColor];
        [self.scanButton setBackgroundImage:scanImage forState:UIControlStateNormal];
        [self.scanButton setBackgroundImage:[UIImage imageNamed:@"navi_scan_n"] forState:UIControlStateHighlighted];
        self.scanButton.hidden = YES;
        self.scanButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:self.scanButton];
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
    
    CGFloat origin = IC_SCREEN_WIDTH - kBSEditCellMargin - kBSEditCellContentWidth;
    
    
//    if (!self.scanButton.hidden) {
//        origin -= 32 + 4.0;
//    }
    
    
    if (!self.arrowImageView.hidden || !self.scanButton.hidden)
    {
        origin -= kBSEditCellArrowSize + 4.0;
    }
    
    if (self.contentField.enabled)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        if (self.arrowImageView.hidden) {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
    }

    
    
    self.contentField.frame = CGRectMake(origin, self.contentField.frame.origin.y, self.contentField.frame.size.width, self.contentField.frame.size.height);
}

@end
