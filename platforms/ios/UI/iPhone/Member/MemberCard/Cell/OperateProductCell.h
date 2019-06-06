//
//  OperateProductCell.h
//  Boss
//
//  Created by lining on 16/5/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberBaseCell.h"

@interface OperateProductCell : MemberBaseCell
+ (instancetype)createCell;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) CDPosBaseProduct *posProduct;

@end
