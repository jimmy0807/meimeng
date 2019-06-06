//
//  BSUpdateMemberRequest.h
//  Boss
//
//  Created by mac on 15/7/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSUpdateMemberRequest : ICRequest
@property(nonatomic,strong)CDMember *member;
@property(nonatomic,strong)NSDictionary *params;
-(id)initWithMember:(CDMember *)member params:(NSDictionary *)params;
@end
