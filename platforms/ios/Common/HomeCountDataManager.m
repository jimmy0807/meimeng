//
//  HomeCountDataManager.m
//  Boss
//
//  Created by jimmy on 15/7/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "HomeCountDataManager.h"
#import "FetchHomeTodayIncomeRequest.h"
#import "FetchHomePassengerFlowRequest.h"
#import "FetchHomeAccountUsersRequest.h"
#import "FetchHomeTodayIncomeRequest.h"
#import "FetchUnreadMessageRequest.h"
#import "ReadMessageRequest.h"

@implementation HomeCountDataManager

IMPSharedManager(HomeCountDataManager)

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        
    }
    
    return self;
}

- (void)fetchData
{
    PersonalProfile* profile = [PersonalProfile currentProfile];
    if ( profile.isLogin )
    {
        [[[FetchUnreadMessageRequest alloc] init] execute];
        if ( profile.roleOption == RoleOption_boss || profile.roleOption == RoleOption_shopManager )
        {
            [[[FetchHomeTodayIncomeRequest alloc] init] execute];
            [[[FetchHomePassengerFlowRequest alloc] init] execute];
        }
        else
        {
            [[[FetchHomeAccountUsersRequest alloc] init] execute];
        }
    }
    
    NSMutableArray *messageIds = [NSMutableArray array];
    NSArray *unSendMessage = [[BSCoreDataManager currentManager] fetchUnSendMessage];
    for (int i = 0; i < unSendMessage.count; i++)
    {
        CDMessage *message = [unSendMessage objectAtIndex:i];
        [messageIds addObject:message.messageID];
    }
    
    if (messageIds.count > 0)
    {
        ReadMessageRequest *request = [[ReadMessageRequest alloc] initWithMessageIds:messageIds];
        [request execute];
    }
}

@end
