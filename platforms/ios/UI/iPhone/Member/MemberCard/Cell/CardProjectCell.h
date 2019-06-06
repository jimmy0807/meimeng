//
//  CardProjectCell.h
//  Boss
//
//  Created by lining on 16/3/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardProjectCell : UITableViewCell

+ (instancetype) createCell;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImg;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arrowImgLeadingConstraint;
@property (assign ,nonatomic) BOOL arrowImgHidden;
@end
