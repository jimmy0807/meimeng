//
//  MemberCardItemCell.h
//  Boss
//
//  Created by mac on 15/7/28.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberCardItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong)UIImageView *lineImageView;
@end
