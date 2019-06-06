//
//  BSSelectItemCell.h
//  Boss
//
//  Created by XiaXianBing on 15/6/1.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBSSelectItemCellHeight       60.0

@interface BSSelectItemCell : UITableViewCell

@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextField *valueTextField;

@end
