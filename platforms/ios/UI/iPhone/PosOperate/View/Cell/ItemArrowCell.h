//
//  ItemArrowCell.h
//  Boss
//
//  Created by lining on 16/9/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemArrowCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lineImgView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (assign, nonatomic) CGFloat lineLeadingConstant;
@property (assign, nonatomic) CGFloat lineTailingConstant;


@end
