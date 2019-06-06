//
//  FetchHZixunRequest.m
//  meim
//
//  Created by jimmy on 2017/4/17.
//
//

#import "FetchHZixunRequest.h"
#import "ChineseToPinyin.h"

#define FETCH_COUNT  50

@interface FetchHZixunRequest ()

@property (nonatomic, assign) kFetchHZixunRequestType type;
@property (nonatomic, strong) NSNumber *storeID;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, strong) NSString *keyword;

@end


@implementation FetchHZixunRequest

- (id)init
{
    self = [super init];
    if (self)
    {
        self.type = kFetchHZixunRequestAll;
    }
    
    return self;
}

- (id)initWithKeyword:(NSString *)keyword
{
    self = [super init];
    if (self)
    {
        self.keyword = keyword;
        self.type = kFetchHZixunRequestSearch;
    }
    
    return self;
}

- (id)initWithStoreID:(NSNumber *)storeID
{
    self = [super init];
    if (self) {
        self.storeID = storeID;
        self.type = kFetchHZixunRequestShopALL;
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
        self.type = kFetchHZixunRequestByPage;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.medical.advisory";
    NSMutableArray *filters = [NSMutableArray array];
    if (self.type == kFetchHZixunRequestAll)
    {
        self.needCompany = true;
        NSString* lastTime = [[BSCoreDataManager currentManager] fetchLastUpdateTimeWithEntityName:@"CDHZixun"];
        if ( lastTime.length > 0 )
        {
            [filters addObject:@[@"write_date", @">", lastTime]];
        }
    }
    else if (self.type == kFetchHZixunRequestShopALL)
    {
        self.needCompany = true;
        if (self.storeID) {
            {
                self.needCompany = false;
                [filters addObject:@[@"shop_id", @"=", self.storeID]];
            }
        }
    }
    else if (self.type == kFetchHZixunRequestByPage)
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
    else if (self.type == kFetchHZixunRequestSearch)
    {
        self.needCompany = false;
        
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
    
    //self.categoryName 的作用是 ?
    NSLog(@"self.categoryName=%@",self.categoryName);
    if (self.categoryName) {
         [filters addObject:@[@"category", @"=", self.categoryName]]; 
    }
    
    self.filter = filters;
    self.field = @[@"id", @"advice", @"category", @"condition", @"customer_id", @"designers_id", @"display_name", @"write_date", @"doctor_id", @"employee_id",@"advisory_product_names", @"create_date",@"name",@"mobile",@"gender",];
    
    NSArray *params = [NSArray array];
    if (self.type == kFetchHZixunRequestByPage)
    {
        params = @[[NSNumber numberWithInteger:self.startIndex], [NSNumber numberWithInteger:self.count], @"id desc"];
    }
    NSLog(@" 请求咨询单参数 =%@",params);
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
        if (self.type == kFetchHZixunRequestAll)
        {
            oldMembers = nil;
        }
        else if (self.type == kFetchHZixunRequestShopALL)
        {
            NSArray *members = [[BSCoreDataManager currentManager] fetchAllHZixunWithStoreID:self.storeID categoryName:self.categoryName];
            oldMembers = [NSMutableArray arrayWithArray:members];
        }
        else if (self.type == kFetchHZixunRequestByPage && self.startIndex == 0)
        {
            NSArray *members = [[BSCoreDataManager currentManager] fetchAllHZixunWithStoreID:self.storeID categoryName:self.categoryName];
            oldMembers = [NSMutableArray arrayWithArray:members];
        }
        else if (self.type == kFetchHZixunRequestSearch)
        {
            searchList = [NSMutableArray array];
        }
#if 1
        for (NSDictionary *params in resultList)
        {
            NSNumber *zixunID = [params objectForKey:@"id"];
            CDHZixun *zixun = [[BSCoreDataManager currentManager] findEntity:@"CDHZixun" withValue:zixunID forKey:@"zixun_id"];
            if( zixun == nil )
            {
                zixun = [[BSCoreDataManager currentManager] insertEntity:@"CDHZixun"];
                zixun.zixun_id = zixunID;
            }
            else
            {
                if (self.type == kFetchHZixunRequestAll || (self.type == kFetchHZixunRequestByPage && self.startIndex == 0))
                {
                    [oldMembers removeObject:zixun];
                }
            }
            
            zixun.advice = [params stringValueForKey:@"advice"];
            zixun.lastUpdate = [params stringValueForKey:@"write_date"];
            zixun.advisory_product_names = [params stringValueForKey:@"advisory_product_names"];
            zixun.category_name = [params stringValueForKey:@"category"];
            zixun.condition = [params stringValueForKey:@"condition"];
            
            zixun.customer_id = [params arrayIDValueForKey:@"customer_id"];
            zixun.customer_name = [params arrayNameValueForKey:@"customer_id"];
            
            zixun.designers_id = [params arrayIDValueForKey:@"designers_id"];
            zixun.designers_name = [params arrayNameValueForKey:@"designers_id"];
            
            zixun.employee_id = [params arrayIDValueForKey:@"employee_id"];
            zixun.employee_name = [params arrayNameValueForKey:@"employee_id"];
            
            zixun.name = [params stringValueForKey:@"name"];
            zixun.time = [params stringValueForKey:@"create_date"];
            
            zixun.mobile = [params stringValueForKey:@"mobile"];
            zixun.gender = [params stringValueForKey:@"gender"];
            
            
            zixun.nameLetter = [ChineseToPinyin pinyinFromChiniseString:zixun.customer_name];
            zixun.nameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:zixun.customer_name] uppercaseString];
            
            if (self.type == kFetchHZixunRequestSearch)
            {
                [searchList addObject:zixun];
            }
        }
#endif
        if (self.type == kFetchHZixunRequestAll || (self.type == kFetchHZixunRequestByPage && self.startIndex == 0))
        {
            [[BSCoreDataManager currentManager] deleteObjects:oldMembers];
        }
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求数据错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHZixunResponse object:searchList userInfo:dict];
}

@end
