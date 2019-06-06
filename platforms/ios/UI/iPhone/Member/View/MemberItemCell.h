//
//  MemberItemCell.h
//  Boss
//
//  Created by lining on 16/4/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberItemCell : UITableViewCell

+ (instancetype)createCell;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arrowImgLeaingConstraint;

@property (strong, nonatomic) IBOutlet UIImageView *iconImgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (assign, nonatomic) BOOL arrowImgViewHidden;
@end
