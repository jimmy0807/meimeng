//
//  BSFetchBookScheduleLinesRequest.m
//  meim
//
//  Created by jimmy on 17/2/15.
//
//

#import "BSFetchBookScheduleLinesRequest.h"

@interface BSFetchBookScheduleLinesRequest ()
@property(nonatomic, strong)NSArray* lineIds;
@end

@implementation BSFetchBookScheduleLinesRequest

- (instancetype)initWithIds:(NSArray*)ids
{
    self = [super init];
    if ( self )
    {
        self.lineIds = ids;
    }
    
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    
    self.tableName = @"born.schedule.line";
    
    NSString* lastUpdateTime = [[BSCoreDataManager currentManager] fetchLastUpdateTimeWithEntityName:@"CDStaffLocalName"];
    if ( lastUpdateTime )
    {
        self.filter = @[@[@"write_date",@">",lastUpdateTime]];
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    NSString* today = [NSString stringWithFormat:@"%@ %@",[dateFormat stringFromDate:[NSDate date]],@"00:00:00"];
    self.filter = @[@[@"write_date",@">",today]];

    //self.filter = @[@[@"id",@"in",self.lineIds]];
    
    self.field = @[@"schedule_id",@"write_date",@"emoloyee_ids",@"display_name"];
    
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
        
        for (NSDictionary *params in retArray)
        {
            NSString* display_name = [params stringValueForKey:@"display_name"];
            NSString* time = [params arrayNameValueForKey:@"schedule_id"];
            NSArray* emoloyee_ids = [params arrayValueForKey:@"emoloyee_ids"];
            for (NSNumber* staffID in emoloyee_ids )
            {
                CDStaffLocalName* s = [[BSCoreDataManager currentManager] findEntity:@"CDStaffLocalName" withPredicateString:[NSString stringWithFormat:@"staffID = %@ && time = \"%@\"", staffID, time]];
                if ( s == nil )
                {
                    s = [[BSCoreDataManager currentManager] insertEntity:@"CDStaffLocalName"];
                    s.time = time;
                    s.staffID = staffID;
                }
                
                CDStaff* staff = [[BSCoreDataManager currentManager] findEntity:@"CDStaff" withValue:staffID forKey:@"staffID"];
                s.name = [NSString stringWithFormat:@"%@(%@)",staff.name,display_name];
                s.lastUpdate = [params stringValueForKey:@"write_date"];
            }
        }
        
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败,请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchBookResponse object:nil userInfo:dict];
}

@end
