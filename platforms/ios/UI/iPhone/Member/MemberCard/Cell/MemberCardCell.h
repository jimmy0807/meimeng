//
//  MemberCardCell.h
//  Boss
//
//  Created by lining on 16/3/25.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberBaseCell.h"

@interface MemberCardCell : UITableViewCell

+ (instancetype)createCell;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (strong, nonatomic) IBOutlet UIImageView *lineImgView;
@property (assign, nonatomic) BOOL arrowImgViewHidden;
@end
