//
//  FetchAllWorkFlowActivity.m
//  ds
//
//  Created by jimmy on 16/10/28.
//
//

#import "FetchAllWorkFlowActivity.h"

@implementation FetchAllWorkFlowActivity

- (BOOL)willStart
{
    self.tableName = @"born.workflow.activity";
    if ( [self.yimeiWorkFlowID integerValue] > 0 )
    {
        self.filter = @[@[@"workflow_id",@"=",self.yimeiWorkFlowID]];
    }
    
    self.field = @[@"display_name",@"id",@"flow_start",@"flow_end",@"parent_activity_id",@"role_option"];
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
        NSArray* array = [dataManager fetchALLWorkFlowActivity];
        NSMutableArray *oldWork = nil;
        if ( array.count > 0 )
        {
            oldWork = [NSMutableArray arrayWithArray:array];
        }
        
        for (NSDictionary *params in resultArray)
        {
            NSNumber* workID = [params numberValueForKey:@"id"];
            CDWorkFlowActivity *work = [dataManager findEntity:@"CDWorkFlowActivity" withValue:workID forKey:@"workID"];
            if ( work )
            {
                [oldWork removeObject:work];
            }
            else
            {
                work = [dataManager insertEntity:@"CDWorkFlowActivity"];
                work.workID = workID;
            }
            
            work.isStart = [params numberValueForKey:@"flow_start"];
            work.isEnd = [params numberValueForKey:@"flow_end"];
            work.name = [params stringValueForKey:@"display_name"];
            work.parentID = [params arrayNotNullIDValueForKey:@"parent_activity_id"];
            work.role = [params numberValueForKey:@"role_option"];
        }
        
        [dataManager deleteObjects:oldWork];
        [dataManager save:nil];
    }
    else
    {
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchWorkFlowActivityResponse object:nil userInfo:dict];
}

@end
