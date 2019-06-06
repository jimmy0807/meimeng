//
//  MemberFollowContentDataSource.h
//  Boss
//
//  Created by lining on 16/5/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionTableDataSource.h"
#import "MemberRecordDataSourceProtocol.h"

@interface MemberFollowContentDataSource : CollectionTableDataSource<UITableViewDataSource,UITableViewDelegate>
//@property (nonatomic, strong) CDMemberFollow *follow;
@property (nonatomic, strong) NSArray *followContents;

@end
