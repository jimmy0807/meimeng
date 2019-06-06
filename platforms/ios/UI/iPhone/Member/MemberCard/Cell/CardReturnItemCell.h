//
//  CardReturnItemCell.h
//  Boss
//
//  Created by lining on 16/6/16.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardReturnItemCell : UITableViewCell
+ (instancetype)createCell;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImgView;

@end
