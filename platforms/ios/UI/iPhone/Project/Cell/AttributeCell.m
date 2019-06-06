//
//  AttributeCell.m
//  Boss
//
//  Created by XiaXianBing on 15/9/2.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "AttributeCell.h"

#define kAttributeCellHeight        44.0
#define kAttributeCellMargin        16.0
#define kAttributeButtonSize        32.0

@interface AttributeCell ()

@property (nonatomic, strong) UIImageView *lineImageView;

@end

@implementation AttributeCell

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
//        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bs_common_cell_h"]];
//        self.selectedBackgroundView.autoresizingMask = 0xff;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAttributeCellMargin, 0.0, IC_SCREEN_WIDTH - 2 * (kAttributeCellMargin + kAttributeButtonSize + 12.0), kAttributeCellHeight)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.titleLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.titleLabel];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.backgroundColor = [UIColor clearColor];
        self.deleteButton.frame = CGRectMake(IC_SCREEN_WIDTH - kAttributeCellMargin - 12.0 - 2 * kAttributeButtonSize, (kAttributeCellHeight - kAttributeButtonSize)/2.0, kAttributeButtonSize, kAttributeButtonSize);
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"attribute_line_delete_n"] forState:UIControlStateNormal];
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"attribute_line_delete_h"] forState:UIControlStateHighlighted];
        [self.deleteButton addTarget:self action:@selector(didDeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:self.deleteButton];
        
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addButton.backgroundColor = [UIColor clearColor];
        self.addButton.frame = CGRectMake(IC_SCREEN_WIDTH - kAttributeCellMargin - kAttributeButtonSize, (kAttributeCellHeight - kAttributeButtonSize)/2.0, kAttributeButtonSize, kAttributeButtonSize);
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"attribute_line_add_n"] forState:UIControlStateNormal];
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"attribute_line_add_h"] forState:UIControlStateHighlighted];
        [self.addButton addTarget:self action:@selector(didAddButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.addButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:self.addButton];
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


#pragma mark -
#pragma mark Requried Methods

- (void)didDeleteButtonClick:(id)sernder
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteAttributeLine:)])
    {
        [self.delegate didDeleteAttributeLine:self];
    }
}

- (void)didAddButtonClick:(id)sernder
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAddAttributeValue:)])
    {
        [self.delegate didAddAttributeValue:self];
    }
}


@end
