//
//  HCustomerCreateRequest.h
//  meim
//
//  Created by jimmy on 2017/4/13.
//
//

#import "ICRequest.h"

@interface HCustomerCreateRequest : ICRequest

- (id)initWithParams:(NSDictionary *)params;
- (id)initWithMemberID:(NSNumber *)memberId params:(NSDictionary *)params;

@end
