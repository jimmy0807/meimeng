//
//  BSFetchMessageTemplateRequest.m
//  Boss
//
//  Created by lining on 16/6/3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchMessageTemplateRequest.h"
#import "NSArray+JSON.h"
/*
 群发短信模板类型字段
//生日 - birthday
//节日 - festival
//优惠 - discount
//沙龙 - salon
//礼物 - gift
*/
@interface BSFetchMessageTemplateRequest ()
@property (nonatomic, strong) NSString *type;
@end

@implementation BSFetchMessageTemplateRequest

- (instancetype)initWithType:(NSString *)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    NSString *cmd = [NSString stringWithFormat:@"%@%@", SERVER_IP ,@"/xmlrpc/2/ds_api"];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"template_type"] = self.type;
     NSString *jsonString = [BNXmlRpc jsonWithArray:@[params]];
    NSString *xmlString = [BNXmlRpc xmlMethod:@"msg_template" jsonString:jsonString];
    [self sendXmlCommand:cmd params:xmlString];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSDictionary *retDict = (NSDictionary *)[BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retDict isKindOfClass:[NSDictionary class]]) {
        
        NSNumber *errorRet = [retDict numberValueForKey:@"errcode"];
        NSString *errorMsg = [retDict stringValueForKey:@"errmsg"];
        if ([errorRet integerValue] == 0) {
            NSMutableArray *oldMessages = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchMemberMessagesWithType:self.type]];
            NSArray* templateMessages = retDict[@"data"];
            for (NSDictionary *params in templateMessages) {
                NSNumber *message_id = [params numberValueForKey:@"id"];
                CDMessageTemplate *messageTemplate = [[BSCoreDataManager currentManager] findEntity:@"CDMessageTemplate" withValue:message_id forKey:@"message_id"];
                if (messageTemplate) {
                    [oldMessages removeObject:messageTemplate];
                }
                else
                {
                    messageTemplate = [[BSCoreDataManager currentManager] insertEntity:@"CDMessageTemplate"];
                    messageTemplate.message_id = message_id;
                }
                messageTemplate.template_id = [params stringValueForKey:@"template_id"];
                messageTemplate.template_name = [params stringValueForKey:@"template_name"];
                messageTemplate.template_type = [params stringValueForKey:@"template_type"];
                messageTemplate.template_content = [params stringValueForKey:@"template_content"];
                
                messageTemplate.descs = [[params arrayValueForKey:@"descs"] toJsonString];
            }
            
            [[BSCoreDataManager currentManager] deleteObjects:oldMessages];
            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            dict = [self generateResponse:errorMsg];
        }
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMessageTemplateResponse object:nil userInfo:dict];
}

@end
