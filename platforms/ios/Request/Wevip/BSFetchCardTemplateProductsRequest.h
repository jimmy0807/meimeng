//
//  BSFetchCardTemplateProductsRequest.h
//  Boss
//
//  Created by lining on 16/4/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchCardTemplateProductsRequest : ICRequest
- (instancetype) initWithTemplate:(CDCardTemplate *)cardTemplate;
@end
