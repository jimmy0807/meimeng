//
//  MemberTezhengDataSource.h
//  Boss
//
//  Created by lining on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol TeZhengDataSourceDelegate<NSObject>
@optional
- (void)didSelectedTezheng:(CDMemberTeZheng *)tezheng;
@end

@interface MemberTezhengDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) id<TeZhengDataSourceDelegate>delegate;

- (instancetype)initWithMember:(CDMember *)member tableView:(UITableView *)tableView;
@end
