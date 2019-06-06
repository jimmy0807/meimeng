//
//  MemberTezhengCell.h
//  Boss
//
//  Created by lining on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberBaseCell.h"

@interface MemberTezhengCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lineImgView;

@property (assign, nonatomic) BOOL arrowImgViewHidden;
+ (instancetype)createCell;

@end
