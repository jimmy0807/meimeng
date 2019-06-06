//
//  CardMergeCell.h
//  Boss
//
//  Created by lining on 16/4/21.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardMergeCell : UITableViewCell

+ (instancetype)createCell;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *discountLabel;

@end
