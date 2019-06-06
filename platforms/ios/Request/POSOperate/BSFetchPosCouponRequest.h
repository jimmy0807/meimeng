//
//  BSFetchPosCouponRequest.h
//  Boss
//
//  Created by lining on 15/11/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchPosCouponRequest : ICRequest
- (instancetype) initWithPosOperate:(CDPosOperate *)operate;
@end
