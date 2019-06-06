//
//  PadProjectCollectionCell.h
//  Boss
//
//  Created by XiaXianBing on 15/10/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPadProjectCollectionCellWidth          223.0
#define kPadProjectCollectionCellHeight         236.0

@interface PadProjectCollectionCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UILabel *imageLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *maskImageView;
@property (nonatomic, strong) UILabel *internalNoLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

- (void)setTipsText:(NSString *)text;

@end
