//
//  FetchUnreadMessageRequest.m
//  Boss
//
//  Created by jimmy on 15/9/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "FetchUnreadMessageRequest.h"

@interface FetchUnreadMessageRequest ()
@property(nonatomic, strong)NSArray* unreadMessage;
@end

@implementation FetchUnreadMessageRequest

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.push";
    
    self.unreadMessage = [[BSCoreDataManager currentManager] fetchAllMessage];
    if (self.unreadMessage.count > 0)
    {
        self.filter = @[@[@"create_date",@">",[[BSCoreDataManager currentManager] fetchMessageLastCreateTime]],@[@"user_id",@"=",[PersonalProfile currentProfile].userID], @[@"state", @"=", @"done"]];
    }
    else
    {
         self.filter = @[@[@"is_open",@"=",@(0)],@[@"user_id",@"=",[PersonalProfile currentProfile].userID], @[@"state", @"=", @"done"]];
    }
    
    self.field = @[@"id", @"title", @"content", @"is_open", @"type", @"state", @"message_type", @"create_date", @"write_date"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if ([retArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        for (NSDictionary *params in retArray)
        {
            NSNumber *messageID = [params numberValueForKey:@"id"];
            CDMessage *message = [dataManager findEntity:@"CDMessage" withValue:messageID forKey:@"messageID"];
            if (!message)
            {
                message = [dataManager insertEntity:@"CDMessage"];
                message.messageID = messageID;
                if (![[params objectForKey:@"is_open"] boolValue])
                {
                    message.isRead = [NSNumber numberWithBool:NO];
                    message.isSend = [NSNumber numberWithBool:NO];
                }
            }
            
            message.title = [params stringValueForKey:@"title"];
            message.content = [params stringValueForKey:@"content"];
            message.time = [params stringValueForKey:@"create_date"];
            message.type = [params stringValueForKey:@"type"];
            message.messageType = [NSNumber numberWithInteger:[[params objectForKey:@"message_type"] integerValue]];
            if ([[params objectForKey:@"is_open"] boolValue])
            {
                message.isRead = [NSNumber numberWithBool:YES];
                message.isSend = [NSNumber numberWithBool:YES];
            }
        }
        [dataManager save:nil];
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchUnReadMessageResponse object:nil userInfo:params];
}

@end
