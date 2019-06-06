//
//  BSFetchBookScheduleRequest.m
//  meim
//
//  Created by jimmy on 17/2/15.
//
//

#import "BSFetchBookScheduleRequest.h"
#import "BSFetchBookScheduleLinesRequest.h"

@implementation BSFetchBookScheduleRequest

- (BOOL)willStart
{
    [super willStart];
    
    self.tableName = @"born.schedule.line";
    
    NSString* lastUpdateTime = [[BSCoreDataManager currentManager] fetchLastUpdateTimeWithEntityName:@"CDStaffLocalName"];
    if ( lastUpdateTime )
    {
        self.filter = @[@[@"write_date",@">",lastUpdateTime]];
    }

    //self.field = @[@"schedule_date",@"write_date",@"line_ids"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        
        NSMutableArray* idsArray = [NSMutableArray array];
        for (NSDictionary *params in retArray)
        {
            NSNumber *book_id = [params numberValueForKey:@"id"];
        }
    }
}

@end
