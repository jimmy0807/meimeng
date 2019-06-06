//
//  ReadMessageRequest.m
//  Boss
//
//  Created by jimmy on 15/9/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ReadMessageRequest.h"

@interface ReadMessageRequest ()

@property (nonatomic, strong) NSArray *messageIds;

@end

@implementation ReadMessageRequest

- (id)initWithMessageIds:(NSArray *)messageIds
{
    self = [super init];
    if (self != nil)
    {
        self.messageIds = messageIds;
    }
    
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    
    self.tableName = @"born.push";
    [self sendShopAssistantXmlWriteCommand:@[self.messageIds, @{@"is_open" : [NSNumber numberWithBool:YES]}]];

    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSDictionary *params;
    if (resultStr.length != 0)
    {
        if ([resultList isKindOfClass:[NSNumber class]])
        {
            NSNumber *isSuccess = (NSNumber *)resultList;
            if (isSuccess.boolValue)
            {
                for (int i = 0; i < self.messageIds.count; i++)
                {
                    NSNumber *messageID = [self.messageIds objectAtIndex:i];
                    CDMessage *message = [[BSCoreDataManager currentManager] findEntity:@"CDMessage" withValue:messageID forKey:@"messageID"];
                    message.isRead = [NSNumber numberWithBool:YES];
                    message.isSend = [NSNumber numberWithBool:YES];
                    [[BSCoreDataManager currentManager] save:nil];
                }
            }
            else
            {
                params = [self generateResponse:@"服务器异常, 请稍后重试"];
            }
        }
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
}

@end
