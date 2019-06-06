//
//  BSLoginRequest.h
//  Boss
//
//  Created by lining on 15/3/31.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSLoginRequest : ICRequest
- (id)initWithUserName:(NSString *)username password:(NSString *)password;
@end
