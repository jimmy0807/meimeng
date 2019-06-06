//
//  FetchHBinglikaDetailRequest.m
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "FetchHBinglikaDetailRequest.h"
#import "FetchHHuizhenRequest.h"
#import "FetchHShoushuRequest.h"

@interface FetchHBinglikaDetailRequest ()
@property (nonatomic, strong) NSNumber *binglikaID;
@end

@implementation FetchHBinglikaDetailRequest

-(id)initWithBinglikaID:(NSNumber*)binglikaID
{
    self = [super init];
    if (self)
    {
        self.binglikaID = binglikaID;
    }
    
    return self;
}

- (BOOL)willStart
{
    if ( self.binglikaID.integerValue == 0 )
        return FALSE;
    
    self.tableName = @"born.medical.records";
    NSMutableArray *filters = [NSMutableArray array];
    
    [filters addObject:@[@"id", @"=", self.binglikaID]];
    
    self.filter = filters;
    self.field = @[@"create_date", @"display_name", @"first_treat_date", @"line_ids", @"member_id", @"mobile", @"write_date",@"records_ids"];
    
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
        for (NSDictionary *params in resultList)
        {
            NSNumber* binglikaID = [params numberValueForKey:@"id"];
            CDHBinglika* ka = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDHBinglika" withValue:binglikaID forKey:@"binglika_id"];
            ka.create_date = [params stringValueForKey:@"create_date"];
            ka.name = [params stringValueForKey:@"display_name"];
            ka.first_treat_date = [params stringValueForKey:@"first_treat_date"];
            ka.member_id = [params arrayIDValueForKey:@"member_id"];
            ka.member_name = [params arrayNameValueForKey:@"member_id"];
            ka.mobile = [params stringValueForKey:@"mobile"];
            ka.lastUpdate = [params stringValueForKey:@"write_date"];
            ka.huizhen = [NSMutableOrderedSet orderedSet];
            
            NSMutableArray* lineIDs = [NSMutableArray array];
            for ( NSNumber* lineID in [params arrayValueForKey:@"line_ids"] )
            {
                CDHHuizhen* huizhen = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDHHuizhen" withValue:lineID forKey:@"huizhen_id"];
                huizhen.binglika = ka;
                [lineIDs addObject:lineID];
            }
            
            FetchHHuizhenRequest* request = [[FetchHHuizhenRequest alloc] initWithBinglikaID:lineIDs];
            request.ka = ka;
            [request execute];
            
            ka.shoushu = [NSMutableOrderedSet orderedSet];
            lineIDs = [NSMutableArray array];
            for ( NSNumber* lineID in [params arrayValueForKey:@"records_ids"] )
            {
                CDHShoushu* shoushu = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDHShoushu" withValue:lineID forKey:@"shoushu_id"];
                shoushu.binglika = ka;
                [lineIDs addObject:lineID];
            }
            
            FetchHShoushuRequest* request2 = [[FetchHShoushuRequest alloc] initWithShoushuID:lineIDs];
            request2.ka = ka;
            [request2 execute];
        }
        
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求数据错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHBinglikaResponse object:searchList userInfo:dict];
}

@end
