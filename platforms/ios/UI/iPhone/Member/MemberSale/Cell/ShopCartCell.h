//
//  ShopCartCell.h
//  Boss
//
//  Created by lining on 16/7/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCartCell : UITableViewCell

+ (instancetype)createCell;

@property (strong, nonatomic) IBOutlet UIImageView *imgeView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLable;
@property (strong, nonatomic) IBOutlet UIImageView *lineImgView;

@end
