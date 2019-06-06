//
//  BSPosOperateCancelRequest.h
//  meim
//
//  Created by jimmy on 2017/6/12.
//
//

#import "ICRequest.h"

@interface BSPosOperateCancelRequest : ICRequest

- (id)initWithParams:(NSDictionary *)params operate:(CDPosOperate*)operate;

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSNumber *operateID;

@end
