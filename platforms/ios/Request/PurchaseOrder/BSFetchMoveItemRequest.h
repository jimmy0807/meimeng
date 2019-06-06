//
//  BSFetchMoveItemRequest.h
//  Boss
//
//  Created by lining on 15/7/17.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchMoveItemRequest : ICRequest
- (id)initWithItemIds:(NSArray *)item_ids;
@end
