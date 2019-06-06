//
//  PosOperateMonthIncomeView.h
//  Boss
//
//  Created by lining on 16/9/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndicatorCollectionViewProtocol.h"

@protocol PosOperateMonthIncomeViewDelegate <NSObject>

@optional
- (void)didSelectedMonthIncome:(CDPosMonthIncome *)monthIncome;

@end

@interface PosOperateMonthIncomeView : UIView<IndicatorCollectionViewProtocol,UITableViewDataSource,UITableViewDelegate>
+ (instancetype)createView;
@property (weak, nonatomic) id<PosOperateMonthIncomeViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIView *noOperateView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
