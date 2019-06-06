//
//  PosOperateSwitchCell.h
//  Boss
//
//  Created by lining on 16/9/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchCellDelegate <NSObject>
@optional
- (void)didSwitchValueChanged:(BOOL)changed;
@end

@interface PosOperateSwitchCell : UITableViewCell
+ (instancetype)createCell;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UISwitch *switchBtn;
@property (strong, nonatomic) IBOutlet UIImageView *lineImgView;
@property (weak, nonatomic) id<SwitchCellDelegate>delegate;

@end
