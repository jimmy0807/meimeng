//
//  BSFetchMoveOrderRequest.h
//  Boss
//  采购单 移动订单
//  Created by lining on 15/7/17.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"


@interface BSFetchMoveOrderRequest : ICRequest
- (id) initWithPurchaseOrder:(CDPurchaseOrder *)purchaseOrder;
@end
