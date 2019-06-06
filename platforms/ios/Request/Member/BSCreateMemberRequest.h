//
//  BSCreateMemberRequest.h
//  Boss
//
//  Created by mac on 15/7/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSCreateMemberRequest : ICRequest
-(id)initWithMember:(CDMember *)member params:(NSDictionary *)params;
@end
