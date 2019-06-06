//
//  rightCell.h
//  Boss
//
//  Created by jiangfei on 16/5/25.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class rightModel;
@interface CategoryRightCell : UITableViewCell
/** rightModel*/
@property (nonatomic,strong)rightModel *rightCellModel;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIView *rightView;

@end
