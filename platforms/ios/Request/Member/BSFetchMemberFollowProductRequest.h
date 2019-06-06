//
//  BSFetchMemberFollowProductRequest.h
//  Boss
//
//  Created by lining on 16/5/9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchMemberFollowProductRequest : ICRequest
@property (strong, nonatomic) CDMemberFollow *follow;
@end
