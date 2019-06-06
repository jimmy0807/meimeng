//
//  CheckMemberExistRequest.m
//  meim
//
//  Created by jimmy on 2017/8/23.
//
//

#import "CheckMemberExistRequest.h"

@implementation CheckMemberExistRequest

- (BOOL)willStart
{
    self.tableName = @"born.member";
    self.field = @[@"id"];
    NSMutableArray *filters = [NSMutableArray array];
    [filters addObject:@[@"mobile", @"=", self.phoneNumber]];
    
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
        if (resultStr.length != 0 && resultList != nil)
        {
            for (NSDictionary *dict in resultList)
            {
                NSNumber *memberID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
                self.gotMeber(memberID);
                
                return;
            }
        }
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    self.gotMeber(nil);
}

@end
