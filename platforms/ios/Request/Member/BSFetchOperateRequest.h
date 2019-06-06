//
//  BSFetchOperateRequest.h
//  Boss
//
//  Created by XiaXianBing on 2016-4-12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

typedef enum kFetchOperateType
{
    kFetchOperateDefault,
    kFetchOperateMemberRecent
}kFetchOperateType;

@interface BSFetchOperateRequest : ICRequest

- (id)initWithOperateIds:(NSArray *)operateIds;
- (id)initWithMember:(CDMember *)member recentOperateIds:(NSArray *)operateIds;

@end
