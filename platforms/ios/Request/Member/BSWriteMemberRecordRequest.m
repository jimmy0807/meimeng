//
//  BSWriteMemberRecordRequest.m
//  meim
//
//  Created by jimmy on 16/11/25.
//
//

#import "BSWriteMemberRecordRequest.h"

@interface BSWriteMemberRecordRequest ()
@property (nonatomic, strong) NSDictionary *params;
@end

@implementation BSWriteMemberRecordRequest

- (instancetype)initWithParams:(NSDictionary *)params
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
    
    self.tableName = @"born.card.record";
    
    [self sendRpcXmlStyle:@"create" params:@[self.params]];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict;
    if ([retArray isKindOfClass:[NSNumber class]]) {
        NSLog(@"创建成功");
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
}

@end
