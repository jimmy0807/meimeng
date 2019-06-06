//
//  HShoushuCreateRequest.h
//  meim
//
//  Created by jimmy on 2017/5/10.
//
//

#import "ICRequest.h"

@interface HShoushuCreateRequest : ICRequest

- (id)initWithShoushuID:(NSNumber *)huizhenID params:(NSDictionary *)params isEdit:(BOOL)isEdit;
@property (nonatomic, strong) NSNumber *shoushuID;

@end
