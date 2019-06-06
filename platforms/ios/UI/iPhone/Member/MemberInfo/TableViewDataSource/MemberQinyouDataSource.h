//
//  MemberQinyouDataSource.h
//  Boss
//
//  Created by lining on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QinyouDataSourceDelegate <NSObject>
@optional
- (void)didSelectedQinyou:(CDMemberQinyou *)qinyou;
@end

@interface MemberQinyouDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property(weak, nonatomic)id<QinyouDataSourceDelegate>delegate;
- (instancetype)initWithMember:(CDMember *)member tableView:(UITableView *)tableView;
@end
