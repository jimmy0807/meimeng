//
//  BSDeleteOperateItemRequest.h
//  meim
//
//  Created by jimmy on 17/2/24.
//
//

#import "ICRequest.h"

@interface BSDeleteOperateItemRequest : ICRequest

- (id)initWithParams:(NSDictionary *)params operate:(CDPosOperate*)operate;

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSNumber *operateID;

@end
