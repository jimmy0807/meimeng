//
//  BSFetchShopRequest.h
//  Boss
//
//  Created by mac on 15/7/13.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSCreateShopRequest : ICRequest
@property(nonatomic,strong)NSDictionary *params;
-(id)initWithParams:(NSDictionary *)params;
@end
