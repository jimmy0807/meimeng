//
//  BSAlipayRequest.m
//  meim
//
//  Created by lining on 2016/12/8.
//
//

#import "BSAlipayTradeRequest.h"

@implementation BSAlipayTradeRequest

- (id)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self)
    {
        self.params = params;
    }
    
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"pos_trade_pay" params:@[self.params]];
    
    return TRUE;
}


- (void)didFinishOnMainThread
{
    NSDictionary *retArray = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSAlipayTradeResponse object:self userInfo:retArray];
}

@end
