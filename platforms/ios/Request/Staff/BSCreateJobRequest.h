//
//  BSCreateJobRequest.h
//  Boss
//
//  Created by mac on 15/7/15.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSCreateJobRequest : ICRequest
;
-(id)initWithStaffJob:(CDStaffJob *)job params:(NSDictionary *)params;
@end
