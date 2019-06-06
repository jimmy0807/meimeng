//
//  BSUomCategoryCreateRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/6/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSUomCategoryCreateRequest : ICRequest

- (id)initWithUomCategoryName:(NSString *)uomCategoryName;
- (id)initWithUomCategoryID:(NSNumber *)uomCategoryID uomCategoryName:(NSString *)uomCategoryName;

@end
