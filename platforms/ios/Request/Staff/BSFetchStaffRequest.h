//
//  BSFetchStaffRequest.h
//  Boss
//
//  Created by lining on 15/5/29.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchStaffRequest : ICRequest
@property(nonatomic, strong) CDStore *shop;
@property(nonatomic, strong) NSNumber *shopID;
@property(nonatomic, assign) bool need_role_id;
@property(nonatomic, strong) NSNumber *userID;
@end
