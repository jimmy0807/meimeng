//
//  FilterBtnCell.h
//  Boss
//
//  Created by lining on 16/5/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterBtnCellDelegate <NSObject>
@optional
- (void)didCancelBtnPressed:(UIButton *)btn;
- (void)didSureBtnPressed:(UIButton *)btn;
@end

@interface FilterBtnCell : UITableViewCell

+ (instancetype)createCell;

@property (nonatomic, weak) id<FilterBtnCellDelegate>delegate;
- (IBAction)cancelBtnPressed:(UIButton *)sender;
- (IBAction)sureBtnPressed:(UIButton *)sender;

@end
