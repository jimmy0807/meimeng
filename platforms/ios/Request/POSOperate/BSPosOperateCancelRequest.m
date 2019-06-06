//
//  BSPosOperateCancelRequest.m
//  meim
//
//  Created by jimmy on 2017/6/12.
//
//

#import "BSPosOperateCancelRequest.h"

@interface BSPosOperateCancelRequest ()
@property (nonatomic, strong) CDPosOperate* operate;
@end

@implementation BSPosOperateCancelRequest

- (id)initWithParams:(NSDictionary *)params operate:(CDPosOperate*)operate
{
    self = [super init];
    if (self != nil)
    {
        self.params = params;
        self.operate = operate;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.card.operate";
    
    self.xmlStyle = @"cancel_ext";
    self.xmlRpcType = rpc_request_write;
    if ( [self.operateID integerValue] > 0 )
    {
        [self sendShopAssistantXmlStandardCommand:@"/xmlrpc/2/object" params:@[@[self.operateID],self.params] method:@"execute"];
    }
    else
    {
        [self sendShopAssistantXmlStandardCommand:@"/xmlrpc/2/object" params:@[@[self.operate.operate_id],self.params] method:@"execute"];
    }
    
    return YES;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (resultStr.length != 0 && [resultList isKindOfClass:[NSNumber class]])
    {
        self.operate.state = @"cancel";
        params[@"rc"] = @(0);
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    if ( self.finished )
    {
        self.finished(params);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSCancelOperateResponse object:dict userInfo:params];
}

@end
