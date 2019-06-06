//
//  MemberFollowInfoDataSource.h
//  Boss
//
//  Created by lining on 16/5/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionTableDataSource.h"

@interface MemberFollowInfoDataSource : CollectionTableDataSource<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) CDMemberFollow *follow;


@end
