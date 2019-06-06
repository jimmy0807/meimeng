//
//  BSFetchPayStatementRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/11/3.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchPayStatementRequest.h"
#import "BSCoreDataManager+Customized.h"

@interface BSFetchPayStatementRequest()
@property (nonatomic, strong) NSArray *statementIds;
@property (nonatomic, strong) NSArray* payModeArray;
@end

@implementation BSFetchPayStatementRequest

- (id)initWithStatementIds:(NSArray *)statementIds
{
    if (self = [super init])
    {
        self.statementIds = statementIds;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"account.bank.statement";
    self.filter = @[@[@"id", @"in", self.statementIds], @[@"state", @"=", @"open"]];
    self.field = @[@"id", @"journal_id", @"balance_end"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return YES;
}

-(void)didFinishOnMainThread
{
    NSArray *resultList = (NSArray *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if ([resultList isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        for (NSDictionary *dict in resultList)
        {
            CDPOSPayMode *paymode = [dataManager findEntity:@"CDPOSPayMode" withValue:[dict arrayValueForKey:@"journal_id"][0] forKey:@"payID"];
            paymode.statementID = [dict numberValueForKey:@"id"];
            paymode.incomeAmount = [NSNumber numberWithFloat:[[dict objectForKey:@"balance_end"] floatValue]];
        }
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPayStatementResponse object:self userInfo:params];
}

@end
