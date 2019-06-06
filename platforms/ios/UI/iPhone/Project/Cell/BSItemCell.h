//
//  BSItemCell.h
//  Boss
//
//  Created by XiaXianBing on 15/6/1.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBSItemCellHeight       60.0

@interface BSItemCell : UITableViewCell

@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end
