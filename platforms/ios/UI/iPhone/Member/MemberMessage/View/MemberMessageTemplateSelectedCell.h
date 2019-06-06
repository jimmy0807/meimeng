//
//  MemberMessageTemplateSelectedCell.h
//  Boss
//
//  Created by lining on 16/6/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberMessageTemplateSelectedCell : UITableViewCell
+ (instancetype)createCell;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImgView;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end
