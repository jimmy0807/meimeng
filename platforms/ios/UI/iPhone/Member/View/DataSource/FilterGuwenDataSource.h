//
//  FilterGuwenDataSource.h
//  Boss
//
//  Created by lining on 16/5/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterBaseDataSource.h"

@protocol FilterGuwenDataSoruceDelegate <NSObject>
@optional
- (void)didSelectedGuwen:(CDStaff *)staff;
@end

@interface FilterGuwenDataSource : FilterBaseDataSource <UITableViewDataSource,UITableViewDelegate>
- (instancetype)initWithStore:(CDStore *)store;
@property (nonatomic, strong) CDStaff *currentStaff;
@property (nonatomic, strong) CDStore *store;
@property (nonatomic, weak) id<FilterGuwenDataSoruceDelegate>delegate;
@end
