//
//  BSFetchMemberRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/11/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchMemberRequest.h"
#import "ChineseToPinyin.h"
#import "BSFetchMemberCardRequest.h"
#import "BSFetchCouponCardRequest.h"
#import "FetchAllMemberIDRequest.h"

#define FETCH_COUNT  50

@interface BSFetchMemberRequest ()

@property (nonatomic, assign) kBSFetchMemberRequestType type;
@property (nonatomic, strong) NSNumber *storeID;
@property (nonatomic, assign) NSInteger startIndex;
//@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString *keyword;

@end


@implementation BSFetchMemberRequest

- (id)init
{
    self = [super init];
    if (self)
    {
        self.type = kBSFetchMemberRequestAll;
    }
    
    return self;
}

- (id)initWithKeyword:(NSString *)keyword
{
    self = [super init];
    if (self)
    {
        self.keyword = keyword;
        self.type = kBSFetchMemberRequestSearch;
    }
    
    return self;
}

- (id)initWithStoreID:(NSNumber *)storeID
{
    self = [super init];
    if (self) {
        self.storeID = storeID;
        self.type = kBSFetchMemberRequsetShopALL;
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
        self.type = kBSFetchMemberRequestByPage;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.member";
    NSMutableArray *filters = [NSMutableArray array];
    if (self.type == kBSFetchMemberRequestAll)
    {
        self.needCompany = true;
        [filters addObject:@[@"is_default_customer", @"=", @(TRUE)]];
        NSString* lastTime = [[BSCoreDataManager currentManager] fetchLastUpdateTimeWithEntityName:@"CDMember"];
        if ( lastTime.length > 0 )
        {
            [filters addObject:@[@"write_date", @">", lastTime]];
        }
    }
    else if (self.type == kBSFetchMemberRequsetShopALL)
    {
        self.needCompany = true;
        if (self.storeID) {
            {
                self.needCompany = false;
                [filters addObject:@[@"shop_id", @"=", self.storeID]];
                [filters addObject:@[@"state", @"=", @"done"]];
            }
        }
        else
        {
            [filters addObject:@[@"state", @"=", @"done"]];
            
        }
    }
    else if (self.type == kBSFetchMemberRequestByPage)
    {
        self.needCompany = true;
        [filters addObject:@[@"state", @"=", @"done"]];
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
    else if (self.type == kBSFetchMemberRequestSearch)
    {
        self.needCompany = false;
        filters = [NSMutableArray array];
        [filters addObject:@"|"];
        [filters addObject:@"|"];
        [filters addObject:@[@"state", @"=", @"done"]];
        [filters addObject:@[@"state", @"=", @"advisory"]];
        [filters addObject:@[@"state", @"=", @"experience"]];
        
        NSString *regex = @"^[0-9]*[1-9][0-9]*$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([predicate evaluateWithObject:self.keyword] && self.keyword.length >= 4 )
        {
            [filters addObject:@[@"mobile", @"like", self.keyword]];
        }
        else
        {
            if ( self.keyword.length >=1 )
            {
                [filters addObject:@[@"name", @"ilike", self.keyword]];
            }
            else
            {
                return FALSE;
            }
        }
        
        [filters addObject:@[@"is_default_customer", @"=", [NSNumber numberWithBool:NO]]];
    }
    if (self.guwenID) {
        [filters addObject:@[@"employee_id",@"=",self.guwenID]];
    }
    
    self.filter = filters;
    NSLog(@"self.filter = %@",self.filter);
    if ( [PersonalProfile currentProfile].isYiMei )
    {
        //@"dj_partner_id",@"dd_partner_id",@"dl_partner_id"
        self.field = @[@"id", @"name", @"no", @"state", @"mobile", @"email", @"gender", @"birth_date", @"write_date", @"is_vip_customer", @"is_default_customer", @"company_id", @"shop_id", @"member_ids", @"coupon_ids", @"is_ad",@"employee_id",@"member_source",@"director_employee_id",@"designers_id",@"member_type",@"dj_partner_id",@"dd_partner_id",@"dl_partner_id",@"member_level"];
    }
    else
    {
        self.field = @[@"id", @"name", @"no", @"state", @"mobile", @"email", @"gender", @"birth_date", @"write_date", @"is_vip_customer", @"is_default_customer", @"company_id", @"shop_id", @"member_ids", @"coupon_ids", @"is_ad",@"employee_id",@"dj_partner_id",@"dd_partner_id",@"dl_partner_id"];
    }
    
    NSArray *params = [NSArray array];
    if (self.type == kBSFetchMemberRequestByPage)
    {
        params = @[[NSNumber numberWithInteger:self.startIndex], [NSNumber numberWithInteger:self.count], @"id asc"];
    }
    [self sendShopAssistantXmlSearchReadCommand:params];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableArray *searchList = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSLog(@"self.type = %d",self.type);

    NSLog(@"resultList = %@",resultList);
    
    if ([resultList isKindOfClass:[NSArray class]])
    {
        NSMutableArray *oldMembers = [NSMutableArray array];
        if (self.type == kBSFetchMemberRequestAll)
        {
            oldMembers = nil;
            if ( self.fetchID )
            {
                FetchAllMemberIDRequest* request = [[FetchAllMemberIDRequest alloc] init];
                [request execute];
            }
        }
        else if (self.type == kBSFetchMemberRequsetShopALL)
        {
            NSArray *members = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.storeID guwenID:self.guwenID];
            oldMembers = [NSMutableArray arrayWithArray:members];
        }
        else if (self.type == kBSFetchMemberRequestByPage && self.startIndex == 0)
        {
            NSArray *members = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.storeID guwenID:self.guwenID];
            oldMembers = [NSMutableArray arrayWithArray:members];
        }
        else if (self.type == kBSFetchMemberRequestSearch)
        {
            searchList = [NSMutableArray array];
        }
        
        for (NSDictionary *params in resultList)
        {
            NSNumber *memberID = [params objectForKey:@"id"];
            CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:memberID forKey:@"memberID"];
            if(member == nil)
            {
                member = [[BSCoreDataManager currentManager] insertEntity:@"CDMember"];
                member.memberID = memberID;
            }
            else
            {
                if (self.type == kBSFetchMemberRequestAll || (self.type == kBSFetchMemberRequestByPage && self.startIndex == 0))
                {
                    [oldMembers removeObject:member];
                }
            }
            
            member.memberNo = [params stringValueForKey:@"no"];
            member.memberName = [params stringValueForKey:@"name"];
            member.isWevipCustom = [params numberValueForKey:@"is_vip_customer"];
            member.isDefaultCustomer = [params numberValueForKey:@"is_default_customer"];
            member.memberNameLetter = [ChineseToPinyin pinyinFromChiniseString:member.memberName];
            member.memberNameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:member.memberName] uppercaseString];
            
            member.employee_name = [params arrayNameValueForKey:@"employee_id"];
            member.director_employee = [params arrayNameValueForKey:@"director_employee_id"];
            member.director_employee_id = [params arrayIDValueForKey:@"director_employee_id"];
            member.member_source = [params arrayNameValueForKey:@"member_source"];
            member.dj_partner = [params arrayNameValueForKey:@"dj_partner_id"];
            member.dd_partner = [params arrayNameValueForKey:@"dd_partner_id"];
            member.dl_partner = [params arrayNameValueForKey:@"dl_partner_id"];
            member.member_level = [params stringValueForKey:@"member_level"];
            
            
            member.member_shejishi_id = [params arrayIDValueForKey:@"designers_id"];
            member.member_shejishi_name = [params arrayNameValueForKey:@"designers_id"];
            
            member.yimei_member_type = [params stringValueForKey:@"member_type"];
            //顾问
            member.member_guwen_id = [params arrayIDValueForKey:@"employee_id"];
            member.member_guwen_name = [params arrayNameValueForKey:@"employee_id"];
            if ([member.member_guwen_id integerValue] > 0) {
                CDStaff *guwen = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDStaff" withValue:member.member_tuijian_vip_id forKey:@"staffID"];
                guwen.name = member.member_guwen_name;
                member.guwen = guwen;
            }
            
            if (member.isDefaultCustomer.boolValue)
            {
                member.memberNameSingleLetter = @"0";
            }
            else
            {
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
            }
            member.imageName = [NSString stringWithFormat:@"%@_%@",memberID, member.memberName];
            member.mobile = [params stringValueForKey:@"mobile"];
            member.email = [params stringValueForKey:@"email"];
            member.gender = [params stringValueForKey:@"gender"];
            member.birthday = [params stringValueForKey:@"birth_date"];
            member.lastUpdate = [params stringValueForKey:@"write_date"];
            if ([[params stringValueForKey:@"state"] isEqualToString:@"done"])
            {
                member.isAcitve = @(TRUE);
            }
            else
            {
                member.isAcitve = @(FALSE);
            }
            
            NSArray *company = [params objectForKey:@"company_id"];
            if ([company isKindOfClass:[NSArray class]] && company.count > 1)
            {
                member.companyID = [NSNumber numberWithInteger:[[company objectAtIndex:0] integerValue]];
                member.companyName = [company objectAtIndex:1];
            }
            
            NSArray *shop = [params objectForKey:@"shop_id"];
            if ([shop isKindOfClass:[NSArray class]] && shop.count > 1)
            {
                NSNumber *storeID = [NSNumber numberWithInteger:[[shop objectAtIndex:0] integerValue]];
                member.storeID = storeID;
                member.storeName = [shop objectAtIndex:1];
                CDStore *store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:storeID forKey:@"storeID"];
                if(!store)
                {
                    store = [[BSCoreDataManager currentManager] insertEntity:@"CDStore"];
                    store.storeID = member.storeID;
                    store.storeName = member.storeName;
                }
                member.store = store;
            }
            
            NSArray *cardIds = [params objectForKey:@"member_ids"];
            NSMutableOrderedSet *memberCardSet = [NSMutableOrderedSet orderedSet];
            for (NSInteger i = 0; i < cardIds.count; i++)
            {
                NSNumber *cardId = [NSNumber numberWithInteger:[[cardIds objectAtIndex:i] integerValue]];
                CDMemberCard *memberCard = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:cardId forKey:@"cardID"];
                if (memberCard == nil)
                {
                    memberCard = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCard"];
                    memberCard.cardID = cardId;
                }
                [memberCardSet addObject:memberCard];
            }
            member.card = [NSOrderedSet orderedSetWithOrderedSet:memberCardSet];
            
            NSArray *couponIds = [params objectForKey:@"coupon_ids"];
            NSMutableOrderedSet *couponCardSet = [NSMutableOrderedSet orderedSet];
            for (NSInteger i = 0; i < couponIds.count; i++)
            {
                NSNumber *couponId = [NSNumber numberWithInteger:[[couponIds objectAtIndex:i] integerValue]];
                CDCouponCard *couponCard = [[BSCoreDataManager currentManager] findEntity:@"CDCouponCard" withValue:couponId forKey:@"cardID"];
                if (couponCard == nil)
                {
                    couponCard = [[BSCoreDataManager currentManager] insertEntity:@"CDCouponCard"];
                    couponCard.cardID = couponId;
                }
                [couponCardSet addObject:couponCard];
            }
            member.coupons = [NSOrderedSet orderedSetWithOrderedSet:couponCardSet];
            
            if (self.type == kBSFetchMemberRequestSearch)
            {
                
                ///因为手机号码搜名字 名字搜手机号都会走这里 所以得做一下区分
                
                //这种区分搜索关键字大小写
//                if ([member.memberName containsString:self.keyword]) {
//                    [searchList addObject:member];
//                }
                
                //不区分搜索关键字大小写
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",self.keyword];
                
                if ([@[member.memberName,member.mobile] filteredArrayUsingPredicate:predicate].count>0) {
                    
                    [searchList addObject:member];
                    
                }
                
            }
        }
        
        if (self.type == kBSFetchMemberRequestAll || (self.type == kBSFetchMemberRequestByPage && self.startIndex == 0))
        {
            [[BSCoreDataManager currentManager] deleteObjects:oldMembers];
        }
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求数据错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberResponse object:searchList userInfo:dict];
}

@end
