//
//  FilterGuwenCell.h
//  Boss
//
//  Created by lining on 16/5/25.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterGuwenCell : UITableViewCell

+ (instancetype)createCell;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImgView;

@end
