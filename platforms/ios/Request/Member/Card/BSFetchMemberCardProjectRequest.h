//
//  BSFetchMemberCardProjectRequest.h
//  Boss
//  卡内项目明细 和 销售
//  Created by XiaXianBing on 15/11/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchMemberCardProjectRequest : ICRequest

- (id)initWithMemberCardID:(NSNumber *)memberCardID;
- (id)initWithMember:(CDMember *)member;
- (id)initWithMemberCardProjectIds:(NSArray *)projectIds;

@end
