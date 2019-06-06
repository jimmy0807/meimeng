//
//  BSFetchMoveDetailRequest.h
//  Boss
//  采购单 移动订单详情
//  Created by lining on 15/7/17.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchMoveDetailRequest : ICRequest
- (id) initWithMoveOrder:(CDPurchaseOrderMove *)moveOrder;
@end
