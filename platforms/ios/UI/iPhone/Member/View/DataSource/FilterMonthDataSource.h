//
//  FilterMonthDataSource.h
//  Boss
//  生日月份
//  Created by lining on 16/5/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterBaseDataSource.h"

@protocol FilterMonthDataSourceDelegate <NSObject>
@optional
- (void)didSelectedMonth:(NSString *)month;

@end

@interface FilterMonthDataSource : FilterBaseDataSource <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString *currentMonth;
@property (nonatomic, weak) id<FilterMonthDataSourceDelegate>delegate;


@end
