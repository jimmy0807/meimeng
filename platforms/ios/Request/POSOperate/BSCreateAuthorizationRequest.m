//
//  BSCreateAuthorizationRequest.m
//  meim
//
//  Created by jimmy on 16/12/27.
//
//

#import "BSCreateAuthorizationRequest.h"

@interface BSCreateAuthorizationRequest ()
@property (nonatomic, strong) NSDictionary *params;
@end

@implementation BSCreateAuthorizationRequest

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
    
    self.tableName = @"born.authorization";
    
    [self sendRpcXmlStyle:@"create" params:@[self.params]];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict;
    if ([retArray isKindOfClass:[NSNumber class]])
    {
        NSLog(@"创建成功");
    }
    else
    {
        retArray = [NSArray array];
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSCreateAuthorizationResponse object:nil userInfo:@{@"userInfo":retArray}];
}

@end
