//
//  BSAlipayRefundRequest.h
//  meim
//
//  Created by lining on 2016/12/8.
//
//

#import "ICRequest.h"

@interface BSAlipayRefundRequest : ICRequest

@property (nonatomic, strong)NSDictionary *params;
@property (nonatomic)NSInteger paymentIndex;

- (id)initWithParams:(NSDictionary *)params;

@end
