//
//  BSFetchOrderProductsRequest.h
//  Boss
//
//  Created by lining on 15/6/16.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchOrderLinesRequest : ICRequest
-(id)initWithOrder:(CDPurchaseOrder *)order order_line:(NSArray *)order_line;
@end
