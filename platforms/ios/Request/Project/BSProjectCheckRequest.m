//
//  BSProjectCheckRequest.m
//  meim
//
//  Created by 波恩公司 on 2018/4/24.
//

#import "BSProjectCheckRequest.h"
#import "BSCoreDataManager.h"

@implementation BSProjectCheckRequest


- (BOOL)willStart
{
    self.tableName = @"born.check.line";
    self.filter = @[];
    self.field = @[@"id", @"product_id", @"qty"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if (resultStr.length != 0 && resultList != nil)
    {
        BSCoreDataManager *coreDataManager = [BSCoreDataManager currentManager];
        NSArray *checkArray = [coreDataManager fetchAllProjectCheck];
        NSMutableArray *oldcheckArray = [NSMutableArray arrayWithArray:checkArray];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *checkID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDProjectCheck *check = [coreDataManager findEntity:@"CDProjectCheck" withValue:checkID forKey:@"checkID"];
            if (check)
            {
                [oldcheckArray removeObject:check];
            }
            else
            {
                check = [coreDataManager insertEntity:@"CDProjectCheck"];
                check.checkID = checkID;
            }
            check.productID = [NSNumber numberWithInteger:[[[dict objectForKey:@"product_id"] objectAtIndex:0] integerValue]];
            check.qty = [dict objectForKey:@"qty"];

        }
        [coreDataManager deleteObjects:oldcheckArray];
        [coreDataManager save:nil];
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectCheckResponse object:self userInfo:params];
}

@end
