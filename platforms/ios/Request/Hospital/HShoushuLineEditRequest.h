//
//  HShoushuLineEditRequest.h
//  meim
//
//  Created by jimmy on 2017/5/11.
//
//

#import "ICRequest.h"

@interface HShoushuLineEditRequest : ICRequest

@property (nonatomic, strong) NSNumber *shoushuID;
- (id)initWithShoushuID:(NSNumber *)shoushuID params:(NSDictionary *)params;

@end
