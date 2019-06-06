//
//  leftCell.h
//  Boss
//
//  Created by jiangfei on 16/5/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDProjectCategory;

@interface CategoryLeftCell : UITableViewCell

/**  标题nameView */
@property (weak, nonatomic) IBOutlet UILabel *titleNameView;
/**  图片imageView */
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
/**  数字View */
@property (weak, nonatomic) IBOutlet UILabel *titleCountView;

/** 数据模型*/
@property (nonatomic,strong)CDProjectCategory *category;

@end
