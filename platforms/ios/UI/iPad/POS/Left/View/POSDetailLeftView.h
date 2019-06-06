//
//  HomeDetailLeftView.h
//  Boss
//
//  Created by lining on 15/10/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol POSDetailLeftViewDelegate<NSObject>
@optional
- (void) didBackBtnPressed;
- (void) didPrintBtnPressed;
- (void) didGiveBtnPressed;
- (void) didEditPosOperateBtnPressed;
- (void) didSelectedOperate:(CDPosOperate *)operate;
- (void) didSelectedPosProduct:(CDPosBaseProduct *)posProduct;
- (void) didSelectedConsumeProduct:(CDPosConsumeProduct *)consumProduct;
@end

@interface POSDetailLeftView : UIView<UITableViewDataSource,UITableViewDelegate>

+ (instancetype)createView;
@property (strong, nonatomic) CDPosOperate *operate;
@property (Weak, nonatomic) id<POSDetailLeftViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *titleBgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtnPressed:(UIButton *)sender;
- (IBAction)printBtnPressed:(UIButton *)sender;
- (IBAction)giveBtnPressed:(UIButton *)sender;

- (void) reloadLeftView;
@end
