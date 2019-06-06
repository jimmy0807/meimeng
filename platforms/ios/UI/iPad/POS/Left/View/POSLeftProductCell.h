//
//  LeftDetailCell.h
//  Boss
//
//  Created by lining on 15/10/15.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POSLeftProductCell : UITableViewCell

+ (instancetype)createCell;
@property (strong, nonatomic) CDPosBaseProduct *posProduct;
//@property (strong, nonatomic) CDPosConsumeProduct *consumeProduct;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *discountLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *tagImgView;
@property (strong, nonatomic) IBOutlet UILabel *rightDetailLabel;
@property (strong, nonatomic) IBOutlet UILabel *buweiLabel;
@end
