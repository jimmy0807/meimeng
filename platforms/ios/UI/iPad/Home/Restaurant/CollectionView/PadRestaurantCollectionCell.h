//
//  PadRestaurantCollectionCell.h
//  Boss
//
//  Created by XiaXianBing on 2016-2-23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPadRestaurantCollectionCellWidth          125.0
#define kPadRestaurantCollectionCellHeight         115.0

typedef enum kPadRestaurantTableType
{
    kPadRestaurantTableNone,
    kPadRestaurantTableNormal,
    kPadRestaurantTableSelected
}kPadRestaurantTableType;

@interface PadRestaurantCollectionCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *ratioImageView;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *seatsLabel;

@property (nonatomic, assign) kPadRestaurantTableType state;

@end
