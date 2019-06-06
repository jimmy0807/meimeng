//
//  BSStaffCreateRequest.h
//  Boss
//
//  Created by mac on 15/7/8.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSStaffCreateRequest : ICRequest

- (id)initWithStaff:(CDStaff *)staff params:(NSDictionary *)params;

@end
