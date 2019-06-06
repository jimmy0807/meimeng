//
//  SubPosCategoryViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface SubPosCategoryViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithParentCategory:(CDProjectCategory *)parentCategory posCategory:(CDProjectCategory *)posCategory;

@property(nonatomic)NSInteger popViewControllerIndex;

@end
