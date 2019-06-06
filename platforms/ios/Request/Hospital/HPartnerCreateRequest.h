//
//  HPartnerCreateRequest.h
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "ICRequest.h"

@interface HPartnerCreateRequest : ICRequest

- (id)initWithPartnerID:(NSNumber *)visitID params:(NSDictionary *)params;

@end
