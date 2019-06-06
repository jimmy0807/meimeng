//
//  FetchAllMemberIDRequest.m
//  meim
//
//  Created by jimmy on 2017/6/3.
//
//

#import "FetchAllMemberIDRequest.h"

@implementation FetchAllMemberIDRequest

- (BOOL)willStart
{
    self.tableName = @"born.member";
    self.field = @[@"id"];
    NSMutableArray *filters = [NSMutableArray array];
    self.needCompany = true;
    [filters addObject:@"|"];
    [filters addObject:@"|"];
    [filters addObject:@[@"state", @"=", @"done"]];
    [filters addObject:@[@"state", @"=", @"advisory"]];
    [filters addObject:@[@"state", @"=", @"experience"]];

    self.filter = filters;
    
    [self sendShopAssistantXmlSearchReadCommand:nil];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if (resultStr.length != 0 && resultList != nil)
    {
        [BSCoreDataManager performBlockOnWriteQueue:^{
            [self doInThread:resultList];
        }];
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
}

- (void)doInThread:(NSArray *)resultList
{
    if (resultStr.length != 0 && resultList != nil)
    {
        BSCoreDataManager *coreDataManager = [BSCoreDataManager currentManager];
        NSArray *items = [coreDataManager fetchAllMember];
        NSMutableArray *oldItems = [NSMutableArray arrayWithArray:items];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *itemID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDMember *item = [coreDataManager findEntity:@"CDMember" withValue:itemID forKey:@"memberID"];
            if (item)
            {
                [oldItems removeObject:item];
            }
        }
        [coreDataManager deleteObjects:oldItems];
        [coreDataManager save:nil];
    }
}

@end
