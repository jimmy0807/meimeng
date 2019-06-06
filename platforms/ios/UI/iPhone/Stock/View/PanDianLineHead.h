//
//  PanDianLineHead.h
//  Boss
//
//  Created by lining on 15/9/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PanDianLineHead : UITableViewCell

@property(nonatomic, strong) UIImageView *picView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UIImageView *arrowImageView;
@property(nonatomic, strong) UIImageView *bottomLineImgView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width;

+ (CGFloat)cellHeight;
@end
