//
//  PanDianCell.h
//  Boss
//
//  Created by lining on 15/9/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanDianCell : UITableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width;

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UIImageView *arrowImageView;

+(CGFloat)cellHeight;

@end
