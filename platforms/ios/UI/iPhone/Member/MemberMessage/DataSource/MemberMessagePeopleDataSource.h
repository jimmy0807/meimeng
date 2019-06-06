//
//  MemberMessagePeopleDataSource.h
//  Boss
//
//  Created by lining on 16/5/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MemberMessagePeopleDataSouceDelegate <NSObject>
@optional
- (void)didSelectedItemsChanged:(NSMutableOrderedSet *)items;
@end

@interface MemberMessagePeopleDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

- (instancetype) initWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) NSArray *filterMembers;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,weak) id<MemberMessagePeopleDataSouceDelegate>delegate;
@property (nonatomic, assign) BOOL allSelected;
@end
