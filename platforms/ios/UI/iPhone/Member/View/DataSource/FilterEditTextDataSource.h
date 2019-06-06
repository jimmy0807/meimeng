//
//  FilterEditTextDataSource.h
//  Boss
//
//  Created by lining on 16/5/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterBaseDataSource.h"
#import "FilterDefine.h"

@class FilterEditTextDataSource;
@protocol FilterEditTextDataSourceDelegate <NSObject>

@optional
- (void)didFilterSureBtnPressed:(FilterEditTextDataSource *)dataSource;
- (void)didFilterCancelBtnPressed:(FilterEditTextDataSource *)dataSource;

@end

@interface FilterEditTextDataSource : FilterBaseDataSource<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *minValue;
@property (nonatomic, strong) NSString *maxValue;
@property (nonatomic, weak) id<FilterEditTextDataSourceDelegate>delegate;
@property (nonatomic, strong) UITableView *tableView;
@end
