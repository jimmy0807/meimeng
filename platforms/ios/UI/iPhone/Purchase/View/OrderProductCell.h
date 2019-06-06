//
//  OrderProductTableViewCell.h
//  Boss
//
//  Created by lining on 15/6/19.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderProductCell : UITableViewCell

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *unitLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *countLabel;
@property(nonatomic, strong) UILabel *noLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width needAccessoryView:(BOOL)needAccessory;

+(CGFloat)cellHeight;

@end
