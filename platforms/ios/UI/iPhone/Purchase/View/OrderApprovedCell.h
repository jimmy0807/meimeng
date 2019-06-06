//
//  OrderApprovedCell.h
//  Boss
//
//  Created by lining on 15/8/19.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderApprovedCell : UITableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width;

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, strong) UILabel *rateLabel;
@property(nonatomic, strong) UILabel *providerLabel;

+(CGFloat)cellHeight;
@end
