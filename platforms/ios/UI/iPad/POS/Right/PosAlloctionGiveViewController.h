//
//  PosAlloctionGiveViewController.h
//  Boss
//
//  Created by lining on 15/10/22.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@protocol PosAllotGiveViewControllerDelegate <NSObject>
@optional
- (void)didSureGiveCount:(NSInteger) count;
@end


@interface PosAlloctionGiveViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)sureBtnPressed:(UIButton *)sender;

@property (assign, nonatomic) NSInteger giveCount;
@property (assign, nonatomic) NSInteger maxGiveCount;
@property (strong, nonatomic) CDPosBaseProduct *posProduct;
@property (Weak, nonatomic) id<PosAllotGiveViewControllerDelegate>delegate;

@end
