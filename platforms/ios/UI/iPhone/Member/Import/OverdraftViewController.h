//
//  OverdraftViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/8/20.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface OverdraftViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithOverdrafts:(NSMutableArray *)overdrafts;

@end
