//
//  BSFetchSpecialStaffRequest.h
//  Boss
//
//  Created by mac on 15/7/21.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchSpecialStaffRequest : ICRequest
- (id)initWithStaff:(CDStaff *)staff;
@property (nonatomic, strong)CDStaff *staff;
@end
