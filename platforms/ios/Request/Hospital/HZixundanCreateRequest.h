//
//  HZixundanCreateRequest.h
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "ICRequest.h"

@interface HZixundanCreateRequest : ICRequest
//- (id)initWithParams:(NSDictionary *)params;
- (id)initWithMemberID:(NSNumber *)memberId params:(NSDictionary *)params;
@end
