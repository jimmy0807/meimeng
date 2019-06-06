//
//  BSFetchProjectRequest.h
//  Boss
//
//  Created by mac on 15/7/31.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchTotalPriceRequest : ICRequest
@property(nonatomic,strong)NSArray *projectIDs;
@property(nonatomic,strong)NSNumber *pricelist_id;
- (id)initWithProjectID:(NSArray *)projectIDs priceListID:(NSNumber *)pricelist_id;
@end
