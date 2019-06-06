//
//  BSFetchMemberFollowRequest.h
//  Boss
//
//  Created by lining on 16/5/9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchMemberFollowRequest : ICRequest
@property (strong, nonatomic) CDMember *member;
@end
