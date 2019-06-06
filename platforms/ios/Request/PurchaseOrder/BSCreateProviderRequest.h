//
//  BSCreateProviderRequest.h
//  Boss
//
//  Created by lining on 15/6/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

@interface BSCreateProviderRequest : ICRequest
//-(id)initWithProvider:(CDProvider *)provider filterDict:(NSDictionary *)filterDict;
-(id)initWithProvider:(CDProvider *)provider params:(NSDictionary *)params;
@end
