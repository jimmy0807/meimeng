//
//  FetchStorageRequest.h
//  Boss
//
//  Created by lining on 15/5/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

//仓位request
#import "ICRequest.h"

@interface BSFetchStorageRequest : ICRequest

@property (nonatomic,strong)NSNumber *storeId;
@end
