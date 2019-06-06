//
//  CardItemViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/8/20.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface CardItemViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithCardItems:(NSMutableArray *)cardItems;

@end
