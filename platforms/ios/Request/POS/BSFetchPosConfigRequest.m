//
//  BSFetchPosConfigRequest.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-2.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchPosConfigRequest.h"
#import "BSFetchPayModeRequest.h"

@interface BSFetchPosConfigRequest ()

@property (nonatomic, strong) NSNumber *posID;

@end

@implementation BSFetchPosConfigRequest

- (id)initWithPosID:(NSNumber *)posID
{
    self = [super init];
    if (self)
    {
        self.posID = posID;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"pos.config";
    if (self.posID.integerValue != 0)
    {
        self.filter = @[@[@"id", @"=", self.posID]];
    }
    self.field = @[@"id", @"name", @"journal_ids"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return YES;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if ([resultList isKindOfClass:[NSArray class]])
    {
        if (self.posID.integerValue != 0)
        {
            if (resultList.count > 0)
            {
                NSDictionary *dict = [resultList firstObject];
                NSArray *journalIds = [dict arrayValueForKey:@"journal_ids"];
                if (journalIds.count > 0)
                {
                    BSFetchPayModeRequest *request = [[BSFetchPayModeRequest alloc] initWithJournalIds:journalIds];
                    [request execute];
                }
            }
        }
        else
        {
            BSCoreDataManager *coreDataManager = [BSCoreDataManager currentManager];
            NSArray *posConfigs = [coreDataManager fetchAllPosConfig];
            NSMutableArray *oldPosConfigs = [NSMutableArray arrayWithArray:posConfigs];
            for (NSDictionary *params in resultList)
            {
                NSNumber *posID = [params numberValueForKey:@"id"];
                CDPosConfig *posConfig = [coreDataManager findEntity:@"CDPosConfig" withValue:posID forKey:@"posID"];
                if (posConfig)
                {
                    [oldPosConfigs removeObject:posConfig];
                }
                else
                {
                    posConfig = [coreDataManager insertEntity:@"CDPosConfig"];
                    posConfig.posID = posID;
                }
                posConfig.posName = [params stringValueForKey:@"name"];
            }
            
            [coreDataManager deleteObjects:oldPosConfigs];
            [coreDataManager save:nil];
        }
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPosConfigResponse object:self userInfo:params];
}

@end
