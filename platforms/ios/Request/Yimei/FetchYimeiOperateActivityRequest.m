//
//  FetchYimeiOperateActivityRequest.m
//  ds
//
//  Created by jimmy on 16/11/7.
//
//

#import "FetchYimeiOperateActivityRequest.h"

@implementation FetchYimeiOperateActivityRequest

- (BOOL)willStart
{
    NSMutableArray *ids = [NSMutableArray array];
    if ( self.ids )
    {
        ids = self.ids;
    }
    else
    {
        for ( CDOperateActivity* a in self.posOperate.yimei_activity )
        {
            [ids addObject:a.lineID];
        }
    }
    
    if ( ids.count == 0 )
        return FALSE;
    
    self.tableName = @"born.operate.activity";
    self.filter = @[@[@"id", @"in", ids]];
    self.field = @[@"activity_id",@"role_option",@"state",@"finish_date",@"user_id"];
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
        for (NSDictionary *params in resultArray)
        {
            NSNumber* workID = [params numberValueForKey:@"id"];
            CDOperateActivity *a = [dataManager uniqueEntityForName:@"CDOperateActivity" withValue:workID forKey:@"lineID"];
            
            a.name = [params arrayNameValueForKey:@"activity_id"];
            a.role = [params numberValueForKey:@"role_option"];
            a.activityID = [params arrayIDValueForKey:@"activity_id"];
            a.state = [params stringValueForKey:@"state"];
            a.time = [params stringValueForKey:@"finish_date"];
            a.userName = [params arrayNameValueForKey:@"user_id"];
        }
        
        [dataManager save:nil];
    }
    else
    {
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchYimeiOperateActivityResponse object:nil userInfo:dict];
}

@end
