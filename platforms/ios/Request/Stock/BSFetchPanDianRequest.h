//
//  BSFetchPanDianRequest.h
//  Boss
//
//  Created by lining on 15/7/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchPanDianRequest : ICRequest
- (id) initWithStartIndex:(NSInteger)startIdx state:(NSString *)state;
@end
