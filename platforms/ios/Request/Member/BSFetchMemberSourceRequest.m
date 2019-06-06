//
//  BSFetchMemberSourceRequest.m
//  ds
//
//  Created by jimmy on 16/10/13.
//
//

#import "BSFetchMemberSourceRequest.h"

@implementation BSFetchMemberSourceRequest

- (BOOL)willStart
{
    self.tableName = @"born.member.source";
    self.field = @[@"display_name",@"id"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([resultArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        [dataManager deleteObjects:[dataManager fetchMemberSource]];
        
        for (NSDictionary *params in resultArray)
        {
            NSNumber* sourceID = [params numberValueForKey:@"id"];
            CDMemberSource *source = [dataManager insertEntity:@"CDMemberSource"];
            source.source_id = sourceID;
            source.name = [params stringValueForKey:@"display_name"];
        }
        
        [dataManager save:nil];
    }
    else
    {
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberSourceResponse object:nil userInfo:dict];
}

@end
