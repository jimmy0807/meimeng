//
//  FetchHFenzhenRequest.m
//  meim
//
//  Created by jimmy on 2017/4/17.
//
//

#import "FetchHFenzhenRequest.h"

#define FETCH_COUNT  50

@interface FetchHFenzhenRequest ()

@property (nonatomic, assign) kFetchHFenzhenRequestType type;
@property (nonatomic, strong) NSNumber *storeID;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, strong) NSString *keyword;

@end


@implementation FetchHFenzhenRequest

- (id)init
{
    self = [super init];
    if (self)
    {
        self.type = kFetchHFenzhenRequestAll;
    }
    
    return self;
}

- (id)initWithKeyword:(NSString *)keyword
{
    self = [super init];
    if (self)
    {
        self.keyword = keyword;
        self.type = kFetchHFenzhenRequestSearch;
    }
    
    return self;
}

- (id)initWithStoreID:(NSNumber *)storeID
{
    self = [super init];
    if (self) {
        self.storeID = storeID;
        self.type = kFetchHFenzhenRequestShopALL;
    }
    return self;
}

- (id)initWithStoreID:(NSNumber *)storeID startIndex:(NSInteger)index
{
    self = [super init];
    if (self)
    {
        self.storeID = storeID;
        self.startIndex = index;
        self.count = FETCH_COUNT;
        self.type = kFetchHFenzhenRequestByPage;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.medical.split";
    NSMutableArray *filters = [NSMutableArray array];
    if (self.type == kFetchHFenzhenRequestAll)
    {
        self.needCompany = true;
        NSString* lastTime = [[BSCoreDataManager currentManager] fetchLastUpdateTimeWithEntityName:@"CDHFenzhen"];
        if ( lastTime.length > 0 )
        {
            [filters addObject:@[@"write_date", @">", lastTime]];
        }
    }
    else if (self.type == kFetchHFenzhenRequestShopALL)
    {
        self.needCompany = true;
        if (self.storeID) {
            {
                self.needCompany = false;
                [filters addObject:@[@"shop_id", @"=", self.storeID]];
            }
        }
    }
    else if (self.type == kFetchHFenzhenRequestByPage)
    {
        if (self.storeID.integerValue != 0)
        {
            [filters addObject:@[@"shop_id", @"=", self.storeID]];
            self.needCompany = false;
        }
        
        if (self.filterString.length != 0)
        {
            NSString *regex = @"^[0-9]*[1-9][0-9]*$";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if ([predicate evaluateWithObject:self.filterString] )
            {
                [filters addObject:@[@"mobile", @"like", self.filterString]];
            }
            else
            {
                [filters addObject:@[@"name", @"ilike", self.filterString]];
            }
        }
        
    }
    else if (self.type == kFetchHFenzhenRequestSearch)
    {
        self.needCompany = false;
        filters = [NSMutableArray array];
        
        NSString *regex = @"^[0-9]*[1-9][0-9]*$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([predicate evaluateWithObject:self.keyword] && self.keyword.length >= 8 )
        {
            [filters addObject:@[@"mobile", @"like", self.keyword]];
        }
        else
        {
            if ( self.keyword.length >=2 )
            {
                [filters addObject:@[@"name", @"ilike", self.keyword]];
            }
            else
            {
                return FALSE;
            }
        }
    }
    
    self.filter = filters;
    self.field = @[@"id", @"advisory_id", @"category_id", @"channel_id", @"content", @"create_date", @"customer_id", @"receiver_id", @"display_name", @"write_date", @"reservation_id", @"type_id"];
    
    NSArray *params = [NSArray array];
    if (self.type == kFetchHFenzhenRequestByPage)
    {
        params = @[[NSNumber numberWithInteger:self.startIndex], [NSNumber numberWithInteger:self.count], @"id asc"];
    }
    [self sendShopAssistantXmlSearchReadCommand:params];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableArray *searchList = nil;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([resultList isKindOfClass:[NSArray class]])
    {
        NSMutableArray *oldMembers = [NSMutableArray array];
        if (self.type == kFetchHFenzhenRequestAll)
        {
            oldMembers = nil;
        }
        else if (self.type == kFetchHFenzhenRequestShopALL)
        {
            NSArray *members = [[BSCoreDataManager currentManager] fetchAllFenzhenWithStoreID:self.storeID];
            oldMembers = [NSMutableArray arrayWithArray:members];
        }
        else if (self.type == kFetchHFenzhenRequestByPage && self.startIndex == 0)
        {
            NSArray *members = [[BSCoreDataManager currentManager] fetchAllFenzhenWithStoreID:self.storeID];
            oldMembers = [NSMutableArray arrayWithArray:members];
        }
        else if (self.type == kFetchHFenzhenRequestSearch)
        {
            searchList = [NSMutableArray array];
        }

        for (NSDictionary *params in resultList)
        {
#if 1
            NSNumber *FenzhenID = [params objectForKey:@"id"];
            CDHFenzhen *fenzhen = [[BSCoreDataManager currentManager] findEntity:@"CDHFenzhen" withValue:FenzhenID forKey:@"fenzhen_id"];
            if( fenzhen == nil )
            {
                fenzhen = [[BSCoreDataManager currentManager] insertEntity:@"CDHFenzhen"];
                fenzhen.fenzhen_id = FenzhenID;
            }
            else
            {
                if (self.type == kFetchHFenzhenRequestAll || (self.type == kFetchHFenzhenRequestByPage && self.startIndex == 0))
                {
                    [oldMembers removeObject:fenzhen];
                }
            }
            
            //[@"id", @"advisory_id", @"category_id", @"channel_id", @"content", @"create_date", @"customer_id", @"receiver_id", @"display_name", @"write_date", @"reservation_id", @"type_id"]
            
            fenzhen.advisory_id = [params arrayIDValueForKey:@"advisory_id"];
            fenzhen.advisory_name = [params arrayNameValueForKey:@"advisory_id"];
            
            fenzhen.lastUpdate = [params stringValueForKey:@"write_date"];
            fenzhen.channel_id = [params numberValueForKey:@"channel_id"];
            fenzhen.content = [params stringValueForKey:@"content"];
            fenzhen.create_date = [params stringValueForKey:@"create_date"];
            
            fenzhen.category_id = [params arrayIDValueForKey:@"category_id"];
            fenzhen.category_name = [params arrayNameValueForKey:@"category_id"];
            
            fenzhen.customer_id = [params arrayIDValueForKey:@"customer_id"];
            fenzhen.customer_name = [params arrayNameValueForKey:@"customer_id"];
            
            fenzhen.receiver_id = [params arrayIDValueForKey:@"receiver_id"];
            fenzhen.receiver_name = [params arrayNameValueForKey:@"receiver_id"];
            
            fenzhen.type_id = [params arrayIDValueForKey:@"type_id"];
            fenzhen.type_name = [params arrayNameValueForKey:@"type_id"];
            
            fenzhen.name = [params stringValueForKey:@"display_name"];
            
            fenzhen.advisory_id = [params numberValueForKey:@"reservation_id"];
            
            if (self.type == kFetchHFenzhenRequestSearch)
            {
                [searchList addObject:fenzhen];
            }
        #endif
        }

        if (self.type == kFetchHFenzhenRequestAll || (self.type == kFetchHFenzhenRequestByPage && self.startIndex == 0))
        {
            [[BSCoreDataManager currentManager] deleteObjects:oldMembers];
        }
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求数据错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchHCustomerResponse object:searchList userInfo:dict];
}

@end
