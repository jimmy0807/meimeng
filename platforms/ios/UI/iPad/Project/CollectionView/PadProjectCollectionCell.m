//
//  PadProjectCollectionCell.m
//  Boss
//
//  Created by XiaXianBing on 15/10/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectCollectionCell.h"
#import "UIImage+Resizable.h"

#define kPadProjectCollectionCellWidth          223.0
#define kPadProjectCollectionCellHeight         236.0
#define kPadProjectCollectionImageWidth         100.0
#define kPadProjectCollectionImageHeight        75.0

@interface PadProjectCollectionCell ()

@property (nonatomic, strong) UIImageView *tipsBackground;
@property (nonatomic, strong) UILabel *tipsLabel;

@end


@implementation PadProjectCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_project_background_n"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_project_background_h"]];
        
        self.tipsBackground = [[UIImageView alloc] initWithFrame:CGRectMake(1.5, 0.0, 96.0, 24.0)];
        self.tipsBackground.backgroundColor = [UIColor clearColor];
        self.tipsBackground.image = [[UIImage imageNamed:@"pad_project_tips"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
        [self.contentView addSubview:self.tipsBackground];
        
        self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 0.0, 96.0 - 2 * 8.0, 24.0)];
        self.tipsLabel.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"pad_project_tips"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 32.0, 12.0, 32.0)]];
        self.tipsLabel.numberOfLines = 1;
        self.tipsLabel.font = [UIFont systemFontOfSize:12.0];
        self.tipsLabel.textAlignment = NSTextAlignmentCenter;
        self.tipsLabel.textColor = [UIColor whiteColor];
        [self.tipsBackground addSubview:self.tipsLabel];
        
        CGFloat originY = 32.0;
        self.imageLabel = [[UILabel alloc] initWithFrame:CGRectMake((kPadProjectCollectionCellWidth - kPadProjectCollectionImageWidth)/2.0, originY, kPadProjectCollectionImageWidth, kPadProjectCollectionImageHeight)];
        self.imageLabel.backgroundColor = [UIColor clearColor];
        self.imageLabel.textColor = COLOR(195.0, 195.0, 195.0, 1.0);
        self.imageLabel.textAlignment = NSTextAlignmentCenter;
        self.imageLabel.font = [UIFont systemFontOfSize:28.0];
        [self.contentView addSubview:self.imageLabel];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kPadProjectCollectionCellWidth - kPadProjectCollectionImageWidth)/2.0, originY, kPadProjectCollectionImageWidth, kPadProjectCollectionImageHeight)];
        self.imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imageView];
        originY += kPadProjectCollectionImageHeight + 8.0;
        
        self.maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadProjectCollectionImageWidth, kPadProjectCollectionImageHeight)];
        self.maskImageView.backgroundColor = [UIColor clearColor];
        self.maskImageView.image = [UIImage imageNamed:@"pad_project_image_mask_n"];
        self.maskImageView.highlightedImage = [UIImage imageNamed:@"pad_project_image_mask_h"];
        [self.imageView addSubview:self.maskImageView];
        
        originY += 5.0;
        self.internalNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0, originY, kPadProjectCollectionCellWidth - 24.0, 20.0)];
        self.internalNoLabel.backgroundColor = [UIColor clearColor];
        self.internalNoLabel.numberOfLines = 1;
        self.internalNoLabel.font = IOS7FONT(14.0);
        self.internalNoLabel.textAlignment = NSTextAlignmentCenter;
        self.internalNoLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.internalNoLabel];
        originY += 20.0;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0, originY, kPadProjectCollectionCellWidth - 24.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        self.titleLabel.font = IOS7FONT(15.0);
        [self.contentView addSubview:self.titleLabel];
        originY += 20.0 + 12.0;
        
        UIImageView *separatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kPadProjectCollectionCellWidth - 16.0)/2.0, originY, 16.0, 2.0)];
        separatedImageView.backgroundColor = COLOR(139.0, 204.0, 204.0, 1.0);
        [self.contentView addSubview:separatedImageView];
        originY += 2.0 + 12.0;
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0, originY, kPadProjectCollectionCellWidth - 24.0, 20.0)];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.numberOfLines = 1;
        self.priceLabel.font = IOS7FONT(16.0);
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.priceLabel];
    }
    
    return self;
}

- (void)setTipsText:(NSString *)text
{
    if (text.length == 0)
    {
        self.tipsBackground.hidden = YES;
        return;
    }
    
    self.tipsBackground.hidden = NO;
    self.tipsLabel.text = text;
    CGSize minSize = [self.tipsLabel.text sizeWithFont:self.tipsLabel.font constrainedToSize:CGSizeMake(1024.0, self.tipsLabel.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat maxWidth = minSize.width;
    if (maxWidth + 16.0 >= 96.0)
    {
        maxWidth = 96.0 - 16.0;
    }
    self.tipsLabel.frame = CGRectMake(self.tipsLabel.frame.origin.x, self.tipsLabel.frame.origin.y, maxWidth, self.tipsLabel.frame.size.height);
    self.tipsBackground.frame = CGRectMake(self.tipsBackground.frame.origin.x, self.tipsBackground.frame.origin.y, maxWidth + 16.0, self.tipsBackground.frame.size.height);
}

@end
