//
//  BSCreateDepartmentRequest.h
//  Boss
//
//  Created by mac on 15/7/14.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSCreateDepartmentRequest : ICRequest

-(id)initWithDepartment:(CDStaffDepartment *)department params:(NSDictionary *)params;
@end
