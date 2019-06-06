//
//  PadRestaurantCollectionCell.m
//  Boss
//
//  Created by XiaXianBing on 2016-2-23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadRestaurantCollectionCell.h"
#import "UIImage+Resizable.h"

@interface PadRestaurantCollectionCell ()

@property (nonatomic, strong) UIImageView *tipsBackground;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation PadRestaurantCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_restaurant_table_background"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_restaurant_table_background"]];
        
        self.maskView = [[UIView alloc] initWithFrame:self.bounds];
        self.maskView.backgroundColor = [UIColor clearColor];
        self.maskView.layer.masksToBounds = YES;
        self.maskView.layer.cornerRadius = 4;
        [self.contentView addSubview:self.maskView];
        
        self.ratioImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadRestaurantCollectionCellWidth, kPadRestaurantCollectionCellHeight)];
        self.ratioImageView.backgroundColor = [UIColor clearColor];
        [self.maskView addSubview:self.ratioImageView];
        
        self.selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadRestaurantCollectionCellWidth, kPadRestaurantCollectionCellHeight)];
        self.selectedImageView.backgroundColor = [UIColor clearColor];
        self.selectedImageView.image = [UIImage imageNamed:@"pad_restaurant_table_selected"];
        self.selectedImageView.hidden = YES;
        [self.maskView addSubview:self.selectedImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 10.0, kPadRestaurantCollectionCellWidth - 24.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.titleLabel.font = IOS7FONTBold(17.0);
        [self.maskView addSubview:self.titleLabel];
        
        self.seatsLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0, kPadRestaurantCollectionCellHeight - 10.0 - 20.0, kPadRestaurantCollectionCellWidth - 24.0, 20.0)];
        self.seatsLabel.backgroundColor = [UIColor clearColor];
        self.seatsLabel.numberOfLines = 1;
        self.seatsLabel.textAlignment = NSTextAlignmentRight;
        self.seatsLabel.textColor = COLOR(179.0, 213.0, 219.0, 1.0);
        self.seatsLabel.font = IOS7FONTBold(14.0);
        [self.maskView addSubview:self.seatsLabel];
    }
    
    return self;
}

- (void)setState:(kPadRestaurantTableType)state
{
    _state = state;
    self.maskView.hidden = NO;
    self.selectedImageView.hidden = YES;
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_restaurant_table_background"]];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_restaurant_table_background"]];
    if (_state == kPadRestaurantTableNone)
    {
        self.maskView.hidden = YES;
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_restaurant_table_add"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pad_restaurant_table_add"]];
    }
    else if (_state == kPadRestaurantTableNormal)
    {
        ;
    }
    else if (_state == kPadRestaurantTableSelected)
    {
        self.selectedImageView.hidden = NO;
    }
}

@end
