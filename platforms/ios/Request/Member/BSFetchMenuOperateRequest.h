//
//  BSFetchMenuOperateRequest.h
//  Boss
//
//  Created by mac on 15/8/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchMenuOperateRequest : ICRequest
@property (nonatomic, strong) NSNumber *userID;
- (id)initWithUserID:(NSNumber *)userID;
@end
