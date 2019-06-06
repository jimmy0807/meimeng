//
//  BSFetchPosPayInfoRequest.h
//  Boss
//
//  Created by lining on 15/10/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchPosPayInfoRequest : ICRequest
- (instancetype)initWithPosOperate:(CDPosOperate *)operate;
@end
