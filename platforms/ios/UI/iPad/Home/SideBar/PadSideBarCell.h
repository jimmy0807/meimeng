//
//  PadSideBarCell.h
//  BornPOS
//
//  Created by XiaXianBing on 15/10/9.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPadSideBarCellWidth        300.0
#define kPadSideBarCellHeight       72.0

@interface PadSideBarCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UIImageView *remindImageView;

@end
