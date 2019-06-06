//
//  BSFetchPosProductRequest.h
//  Boss
//  消费或开卡的项目
//  Created by lining on 15/10/19.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchPosProductRequest : ICRequest
- (instancetype)initWithPosOperate:(CDPosOperate *)operate;
- (instancetype)initWithOperateIds:(NSArray *)ids;
@end
