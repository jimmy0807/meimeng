//
//  BSFetchMemberFollowContentRequest.h
//  Boss
//
//  Created by lining on 16/5/13.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchMemberFollowContentRequest : ICRequest
@property (strong, nonatomic) CDMemberFollow *follow;
@end
