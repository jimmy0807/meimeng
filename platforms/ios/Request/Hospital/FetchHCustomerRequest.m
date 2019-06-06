//
//  FetchHCustomerRequest.m
//  meim
//
//  Created by jimmy on 2017/4/12.
//
//

#import "FetchHCustomerRequest.h"
#import "ChineseToPinyin.h"

#define FETCH_COUNT  50

@interface FetchHCustomerRequest ()

@property (nonatomic, assign) kBSFetchCustomerRequestType type;
@property (nonatomic, strong) NSNumber *storeID;
@property (nonatomic, assign) NSInteger startIndex;
//@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString *keyword;

@end


@implementation FetchHCustomerRequest

- (id)init
{
    self = [super init];
    if (self)
    {
        self.type = kBSFetchCustomerRequestAll;
    }
    
    return self;
}

- (id)initWithKeyword:(NSString *)keyword
{
    self = [super init];
    if (self)
    {
        self.keyword = keyword;
        self.type = kBSFetchCustomerRequestSearch;
    }
    
    return self;
}

- (id)initWithStoreID:(NSNumber *)storeID
{
    self = [super init];
    if (self) {
        self.storeID = storeID;
        self.type = kBSFetchCustomerRequsetShopALL;
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
        self.type = kBSFetchCustomerRequestByPage;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.medical.customer";
    NSMutableArray *filters = [NSMutableArray array];
    if (self.type == kBSFetchCustomerRequestAll)
    {
        self.needCompany = true;
        NSString* lastTime = [[BSCoreDataManager currentManager] fetchLastUpdateTimeWithEntityName:@"CDHCustomer"];
        if ( lastTime.length > 0 )
        {
            //[filters addObject:@[@"write_date", @">", lastTime]];
        }
    }
    else if (self.type == kBSFetchCustomerRequsetShopALL)
    {
        self.needCompany = true;
        if (self.storeID) {
            {
                self.needCompany = false;
                [filters addObject:@[@"shop_id", @"=", self.storeID]];
            }
        }
    }
    else if (self.type == kBSFetchCustomerRequestByPage)
    {
        self.needCompany = true;
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
    else if (self.type == kBSFetchCustomerRequestSearch)
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
    self.field = @[@"id", @"name", @"parent_id", @"recommend_member_id", @"mobile", @"channel_id", @"gender", @"write_date", @"shop_id", @"note", @"street",@"note",@"create_date",@"is_medical"];
    
    NSArray *params = [NSArray array];
    if (self.type == kBSFetchCustomerRequestByPage)
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
        if (self.type == kBSFetchCustomerRequestAll)
        {
            NSArray *members = [[BSCoreDataManager currentManager] fetchAllCustomerWithStoreID:self.storeID];
            oldMembers = [NSMutableArray arrayWithArray:members];
        }
        else if (self.type == kBSFetchCustomerRequsetShopALL)
        {
            NSArray *members = [[BSCoreDataManager currentManager] fetchAllCustomerWithStoreID:self.storeID];
            oldMembers = [NSMutableArray arrayWithArray:members];
        }
        else if (self.type == kBSFetchCustomerRequestByPage && self.startIndex == 0)
        {
            NSArray *members = [[BSCoreDataManager currentManager] fetchAllCustomerWithStoreID:self.storeID];
            oldMembers = [NSMutableArray arrayWithArray:members];
        }
        else if (self.type == kBSFetchCustomerRequestSearch)
        {
            searchList = [NSMutableArray array];
        }
        
        for (NSDictionary *params in resultList)
        {
            NSNumber *memberID = [params objectForKey:@"id"];
            CDHCustomer *member = [[BSCoreDataManager currentManager] findEntity:@"CDHCustomer" withValue:memberID forKey:@"memberID"];
            if(member == nil)
            {
                member = [[BSCoreDataManager currentManager] insertEntity:@"CDHCustomer"];
                member.memberID = memberID;
            }
            else
            {
                if (self.type == kBSFetchCustomerRequestAll || (self.type == kBSFetchCustomerRequestByPage && self.startIndex == 0))
                {
                    [oldMembers removeObject:member];
                }
            }
            
            member.memberName = [params stringValueForKey:@"name"];
            member.memberNameLetter = [ChineseToPinyin pinyinFromChiniseString:member.memberName];
            member.memberNameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:member.memberName] uppercaseString];
            
            if (member.memberNameFirstLetter.length != 0)
            {
                NSString *singleLetter = [member.memberNameFirstLetter substringToIndex:1];
                if ([ChineseToPinyin isFirstLetterValidate:singleLetter])
                {
                    member.memberNameSingleLetter = singleLetter;
                }
                else
                {
                    member.memberNameSingleLetter = @"a";
                }
            }
            else
            {
                member.memberNameSingleLetter = @"a";
            }
            
            member.imageName = [NSString stringWithFormat:@"C%@_%@",memberID, member.memberName];
            member.mobile = [params stringValueForKey:@"mobile"];
            member.gender = [params stringValueForKey:@"gender"];
            member.lastUpdate = [params stringValueForKey:@"write_date"];
            
            NSArray *shop = [params objectForKey:@"shop_id"];
            NSNumber *storeID = [NSNumber numberWithInteger:[[shop objectAtIndex:0] integerValue]];
            member.storeID = storeID;
            
            member.tuijian_kehu_name = [params arrayNameValueForKey:@"parent_id"];
            member.tuijian_kehu_id = [params arrayIDValueForKey:@"parent_id"];
            member.tuijian_member_name = [params arrayNameValueForKey:@"recommend_member_id"];
            member.tuijian_member_id = [params arrayIDValueForKey:@"recommend_member_id"];
            member.partner_name = [params arrayNameValueForKey:@"channel_id"];
            member.partner_name_id = [params arrayIDValueForKey:@"channel_id"];
            member.member_address = [params stringValueForKey:@"street"];
            member.remark = [params stringValueForKey:@"note"];
            member.create_date = [params stringValueForKey:@"create_date"];
            member.is_operate = [params numberValueForKey:@"is_medical"];
            
            if (self.type == kBSFetchCustomerRequestSearch)
            {
                [searchList addObject:member];
            }
        }
        
        if (self.type == kBSFetchCustomerRequestAll || (self.type == kBSFetchCustomerRequestByPage && self.startIndex == 0))
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
