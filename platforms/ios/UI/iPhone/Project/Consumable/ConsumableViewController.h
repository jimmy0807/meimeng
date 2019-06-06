//
//  ConsumableViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface ConsumableViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithConsumables:(NSMutableArray *)consumables;

@end
