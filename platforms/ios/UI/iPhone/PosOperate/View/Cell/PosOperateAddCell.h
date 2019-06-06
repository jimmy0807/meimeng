//
//  PosOperateAddCell.h
//  Boss
//
//  Created by lining on 16/9/5.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PosOperateAddCell : UITableViewCell
+ (instancetype)createCell;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lineImgView;

@end
