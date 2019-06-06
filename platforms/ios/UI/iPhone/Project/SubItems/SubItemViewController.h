//
//  SubItemViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface SubItemViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithSubItems:(NSMutableArray *)subItems projectType:(kPadBornCategoryType)projectType;

@end
