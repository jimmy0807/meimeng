//
//  MemberFilterView.h
//  Boss
//
//  Created by lining on 16/5/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterView.h"

@protocol MemberFilterViewDelegate <NSObject>
@optional
- (void)didFilterMembers:(NSArray *)filterMembers;
- (BOOL)notSendRequestWhenFilterIsNull;
@end

@interface MemberFilterView : UIView<FilterViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FilterView *filterView;
@property (nonatomic, strong) NSArray *filterMembers;
@property (nonatomic, strong) CDStore *store;
@property (nonatomic, weak) id<MemberFilterViewDelegate>delegate;
//@property (nonatomic, strong) MemberDataSource *dataSource;
- (instancetype)initWithStore:(CDStore *)store;
@end
