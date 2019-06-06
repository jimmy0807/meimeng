//
//  BSMemberCreateRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/10/29.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSMemberCreateRequest : ICRequest

- (id)initWithParams:(NSDictionary *)params;
- (id)initWithMemberID:(NSNumber *)memberId params:(NSDictionary *)params;

@end
