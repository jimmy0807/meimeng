//
//  BSAlipayRequest.h
//  meim
//
//  Created by lining on 2016/12/8.
//
//

#import "ICRequest.h"

@interface BSAlipayTradeRequest : ICRequest

@property (nonatomic, strong)NSDictionary *params;
@property (nonatomic, strong)CDPOSPayMode* paymode;

- (id)initWithParams:(NSDictionary *)params;

@end
