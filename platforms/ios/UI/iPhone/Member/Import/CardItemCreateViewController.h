//
//  CardItemCreateViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/8/20.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "BSSwitchCell.h"

@interface CardItemCreateViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate, BSSwitchCellDelegate>

- (id)initWithCardItems:(NSMutableArray *)cardItems editIndex:(NSInteger)index;

@end
