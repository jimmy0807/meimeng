//
//  HHuizhenCreateRequest.h
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "ICRequest.h"

@interface HHuizhenCreateRequest : ICRequest

- (id)initWithHuizhenID:(NSNumber *)huizhenID params:(NSDictionary *)params isEdit:(BOOL)isEdit;

@end
