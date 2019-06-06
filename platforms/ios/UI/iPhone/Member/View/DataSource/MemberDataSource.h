//
//  MemberDataSource.h
//  Boss
//
//  Created by lining on 16/5/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MemberDataSourceDelegate <NSObject>
@optional
- (void)didSelectedMemberAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface MemberDataSource : NSObject <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *filterMembers;
@property (nonatomic, weak) id<MemberDataSourceDelegate>delegate;
- (instancetype) initWithTableView:(UITableView *)tableView;
@end
