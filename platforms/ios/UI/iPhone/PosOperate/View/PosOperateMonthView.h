//
//  PosOperateMonthDataSource.h
//  Boss
//
//  Created by lining on 16/8/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndicatorCollectionViewProtocol.h"
#import "PosOperateViewDelegate.h"

@interface PosOperateMonthView : UIView<UITableViewDataSource,UITableViewDelegate>
+ (instancetype)createView;

@property (weak, nonatomic) id<PosOperateViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIView *noOperateView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong)CDPosMonthIncome *income;
- (void)reloadView;
@end
