//
//  BSItemAddCell.h
//  Boss
//
//  Created by XiaXianBing on 15/8/18.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBSItemAddCellHeight       50.0

@interface BSItemAddCell : UITableViewCell

@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setTitle:(NSString *)title addImageViewHidden:(BOOL)hidden;

@end
