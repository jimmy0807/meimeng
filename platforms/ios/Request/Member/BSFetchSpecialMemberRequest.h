//
//  BSFetchSpecialMember.h
//  Boss
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchSpecialMemberRequest : ICRequest
@property(nonatomic ,retain)NSString *text;
@property(nonatomic,assign)NSNumber *shopID;
- (id)initWithText:(NSString *)text shopID:(NSNumber *)shopID;
@end
