//
//  BSFetchMemberQinyouRequest.h
//  Boss
//
//  Created by lining on 16/3/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchMemberQinyouRequest : ICRequest
- (instancetype) initWithMember:(CDMember *)member;
- (instancetype) initWithPosCardNo:(NSString *)posCardNo;
@end
