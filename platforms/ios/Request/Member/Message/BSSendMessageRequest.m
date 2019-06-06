//
//  BSSendMessageRequest.m
//  Boss
//
//  Created by lining on 16/6/21.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSSendMessageRequest.h"

@interface BSSendMessageRequest()
@property (nonatomic, strong) NSArray *paramArray;
@end

@implementation BSSendMessageRequest
- (instancetype)initWithParamArray:(NSArray *)paramArray
{
    self = [super init];
    if (self) {
        self.paramArray = paramArray;
    }
    
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    NSString *cmd = [NSString stringWithFormat:@"%@%@", SERVER_IP ,@"/xmlrpc/2/ds_api"];
    
//    NSString *jsonString = [BNXmlRpc jsonWithArray:@[self.params]];
    NSString *jsonString = [BNXmlRpc jsonWithArray:self.paramArray];
    NSString *xmlString = [BNXmlRpc xmlMethod:@"send_message_bulk" jsonString:jsonString];
    [self sendXmlCommand:cmd params:xmlString];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSDictionary *retDict = (NSDictionary *)[BNXmlRpc arrayWithXmlRpc:self.resultStr];
//    NSLog(@"retDict: %@",retDict);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([[retDict numberValueForKey:@"errcode"] integerValue] == 0) {
        NSLog(@"群发成功");
    }
    else
    {
        dict = [self generateResponse:@"短信发送失败"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSMemberQufaMessageResponse object:nil userInfo:dict];
}

@end
