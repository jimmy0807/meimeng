//
//  FetchHShoushuRequest.m
//  meim
//
//  Created by jimmy on 2017/5/9.
//
//

#import "FetchHShoushuRequest.h"
#import "FetchHShoushuLineRequest.h"

@interface FetchHShoushuRequest ()
@property (nonatomic, strong)NSArray *shoushuIDs;
@end

@implementation FetchHShoushuRequest

-(id)initWithShoushuID:(NSArray*)shoushuIDs
{
    self = [super init];
    if (self)
    {
        self.shoushuIDs = shoushuIDs;
    }
    
    return self;
}

- (BOOL)willStart
{
    if ( self.shoushuIDs.count == 0 )
        return FALSE;
    
    self.tableName = @"born.medical.operate";
    NSMutableArray *filters = [NSMutableArray array];
    
    [filters addObject:@[@"id", @"in", self.shoushuIDs]];
    
    self.filter = filters;
    self.field = @[@"create_date", @"display_name", @"doctor_id", @"expander_in_date", @"expander_review_1", @"expander_review_2",@"expander_review_3",@"expander_review_days_1",@"expander_review_days_1",@"expander_review_days_1",@"write_date",@"note",@"first_treat_date",@"member_id",@"line_ids"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableArray *searchList = nil;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([resultList isKindOfClass:[NSArray class]])
    {
        NSMutableArray* lineIDs = [NSMutableArray array];
        
        for (NSDictionary *params in resultList)
        {
            NSNumber* shoushuID = [params numberValueForKey:@"id"];
            CDHShoushu* shoushu = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDHShoushu" withValue:shoushuID forKey:@"shoushu_id"];
            shoushu.create_date = [params stringValueForKey:@"create_date"];
            shoushu.name = [params stringValueForKey:@"display_name"];
            shoushu.doctor_id = [params arrayIDValueForKey:@"doctor_id"];
            shoushu.doctor_name = [params arrayNameValueForKey:@"doctor_id"];
            shoushu.expander_in_date = [params stringValueForKey:@"expander_in_date"];
            shoushu.expander_review_1 = [params stringValueForKey:@"expander_review_1"];
            shoushu.expander_review_2 = [params stringValueForKey:@"expander_review_2"];
            shoushu.expander_review_3 = [params stringValueForKey:@"expander_review_3"];
            shoushu.expander_review_days_1 = [params stringValueForKey:@"expander_review_days_1"];
            shoushu.expander_review_days_2 = [params stringValueForKey:@"expander_review_days_2"];
            shoushu.expander_review_days_3 = [params stringValueForKey:@"expander_review_days_3"];
            shoushu.lastUpdate = [params stringValueForKey:@"write_date"];
            //shoushu.note = [params stringValueForKey:@"note"];
            shoushu.first_treat_date = [params stringValueForKey:@"first_treat_date"];
            shoushu.member_id = [params arrayIDValueForKey:@"member_id"];
            shoushu.member_name = [params arrayNameValueForKey:@"member_id"];

            shoushu.items = [NSMutableOrderedSet orderedSet];
            
            for ( NSNumber* lineID in [params arrayValueForKey:@"line_ids"] )
            {
                CDHShoushuLine* line = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDHShoushuLine" withValue:lineID forKey:@"line_id"];
                line.shoushu = shoushu;
                [lineIDs addObject:lineID];
            }
        }
        
        FetchHShoushuLineRequest* request = [[FetchHShoushuLineRequest alloc] initWithShoushuID:lineIDs];
        [request execute];
        
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求数据错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHShoushuResponse object:searchList userInfo:dict];
}

@end
