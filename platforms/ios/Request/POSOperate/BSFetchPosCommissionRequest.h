//
//  BSFetchPosCommissionRequest.h
//  Boss
//
//  Created by lining on 15/11/12.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchPosCommissionRequest : ICRequest
- (instancetype)initWithPosOperate:(CDPosOperate *)operate;
@end
