//
//  BSUpdateMemberFollowRequest.h
//  Boss
//
//  Created by lining on 16/5/17.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSUpdateMemberFollowRequest : ICRequest
@property (nonatomic, strong) CDMemberFollow *follow;
@property (nonatomic, strong) NSDictionary *params;
- (id)initWithFollow:(CDMemberFollow *)follow params:(NSDictionary *)params;
@end
