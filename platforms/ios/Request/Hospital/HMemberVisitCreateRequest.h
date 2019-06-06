//
//  HMemberVisitCreateRequest.h
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "ICRequest.h"

@interface HMemberVisitCreateRequest : ICRequest

- (id)initWithVisitID:(NSNumber *)visitID params:(NSDictionary *)params;

@end
