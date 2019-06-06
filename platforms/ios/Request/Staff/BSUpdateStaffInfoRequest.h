//
//  BSUpdateStaffInfoRequest.h
//  Boss
//
//  Created by mac on 15/7/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSUpdateStaffInfoRequest : ICRequest
- (id)initWithStaffID:(NSNumber *)staffID attributeDic:(NSDictionary *)params;
@property(nonatomic,strong)NSNumber *staffID;
@property(nonatomic,strong)NSDictionary *params;
@end
