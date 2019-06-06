//
//  TextFieldCell.h
//  Boss
//
//  Created by lining on 16/7/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldCell : UITableViewCell
+ (instancetype)createCell;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *valueTextFiled;
@property (strong, nonatomic) IBOutlet UIImageView *lineImgView;

@property (assign, nonatomic) CGFloat lineLeadingConstant;
@property (assign, nonatomic) CGFloat lineTailingConstant;
@end
