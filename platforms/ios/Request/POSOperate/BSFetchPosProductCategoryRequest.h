//
//  BSFetchPosProductCategoryRequest.h
//  Boss
//
//  Created by lining on 16/9/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchPosProductCategoryRequest : ICRequest
@property (nonatomic, strong) NSArray *fetchProductIDs;
@end
