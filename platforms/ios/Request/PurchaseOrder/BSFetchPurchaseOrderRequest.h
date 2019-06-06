//
//  BSFetchPurchaseRequest.h
//  Boss
//
//  Created by lining on 15/6/15.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchPurchaseOrderRequest : ICRequest
- (id)initWithStartIndex:(NSInteger)startIdx state:(NSString *)state;
@end
