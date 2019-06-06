//
//  BSFetchMemberCardRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/11/2.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchMemberCardRequest.h"
#import "BSFetchMemberCardProjectRequest.h"
#import "TempManager.h"

typedef enum kFetchMemberCardType
{
    kFetchMemberCardAll,
    kFetchMemberCardWithMemberCardIds,
    kSearchMemberCardWithMemberCardIds,
    kFetchMemberCardWithMemberId,
}kFetchMemberCardType;

@interface BSFetchMemberCardRequest ()
@property (nonatomic, strong) NSArray *memberCardIds;
@property (nonatomic, assign) kFetchMemberCardType type;
@property (nonatomic, strong) NSMutableArray* searchCardIDs;
@property (nonatomic, strong) NSString* keyword;
@property (nonatomic, strong) NSNumber *memberID;
@end

@implementation BSFetchMemberCardRequest

- (id)init
{
    self = [super init];
    if (self)
    {
        self.type = kFetchMemberCardAll;
    }
    
    return self;
}

- (id)initWithMemberCardIds:(NSArray *)memberCardIds
{
    if (self = [super init])
    {
        self.memberCardIds = memberCardIds;
        self.type = kFetchMemberCardWithMemberCardIds;
    }
    
    return self;
}

- (id)initWithMemberCardIds:(NSMutableArray *)memberCardIds keyword:(NSString*)keyword
{
    if (self = [super init])
    {
        self.searchCardIDs = memberCardIds;
        self.keyword = keyword;
        self.type = kSearchMemberCardWithMemberCardIds;
    }
    
    return self;
}


- (id)initWithMemberID:(NSNumber *)memberID
{
    self = [super init];
    if (self) {
        self.memberID = memberID;
        self.type = kFetchMemberCardWithMemberId;
    }
    return self;
}


- (BOOL)willStart
{
    self.tableName = @"born.card";
    if (self.type == kFetchMemberCardWithMemberCardIds)
    {
        self.filter = @[@[@"id", @"in", self.memberCardIds], @[@"state", @"=", @"active"]];
    }
    else if (self.type == kFetchMemberCardWithMemberId)
    {
        self.filter = @[@[@"member_id",@"=",self.memberID]];
    }
    else
    {
        if ( self.keyword.length >= 6 )
        {
            if ( [TempManager sharedInstance].notSearchAll )
            {
                self.filter = @[@[@"default_code", @"=", self.keyword]];
                [TempManager sharedInstance].notSearchAll = FALSE;
            }
            else
            {
                self.filter = @[@"|",@"|",@[@"id", @"in", self.searchCardIDs],@[@"no", @"ilike", self.keyword],@[@"default_code", @"ilike", self.keyword]];
            }
        }
        else
        {
            if ( self.searchCardIDs )
            {
                self.filter = @[@[@"id", @"in", self.searchCardIDs]];
            }
        }
    }
    
    self.field = @[@"id", @"no", @"name", @"shop_id", @"born_uuid", @"amount", @"course_remain_amount", @"give_amount", @"arrears_amount", @"course_arrears_amount", @"state", @"captcha", @"points",  @"invalid_date", @"member_id", @"pricelist_id", @"arrears_ids", @"product_ids", @"product_all_ids",@"is_invalid", @"default_code"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableArray *productArray = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([resultArray isKindOfClass:[NSArray class]])
    {
        NSMutableArray *oldMemberCards = [NSMutableArray array];
        NSArray *memberCards;
        if (self.type == kFetchMemberCardAll)
        {
             memberCards = [[BSCoreDataManager currentManager] fetchAllMemberCard];
        }
        else if (self.type == kFetchMemberCardWithMemberCardIds)
        {
            memberCards = [[BSCoreDataManager currentManager] fetchMemberCardWithIDs:self.memberCardIds];
        }
        else if (self.type == kSearchMemberCardWithMemberCardIds)
        {
            memberCards = [[BSCoreDataManager currentManager] fetchMemberCardWithIDs:self.searchCardIDs];
        }
        else if (self.type == kFetchMemberCardWithMemberId)
        {
            memberCards = [[BSCoreDataManager currentManager] fetchMemberCardWithMemberID:self.memberID];
        }
        oldMemberCards = [NSMutableArray arrayWithArray:memberCards];
        
        for (NSDictionary *params in resultArray)
        {
            NSString *state = [params stringValueForKey:@"state"];
            if ( ![state isEqualToString:@"active"] )
            {
                continue;
            }
            
            NSNumber *cardID = [params numberValueForKey:@"id"];
            [self.searchCardIDs addObject:cardID];
            CDMemberCard *card = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:cardID forKey:@"cardID"];
            if (card == nil)
            {
                card = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCard"];
                card.cardID = cardID;
            }
            else
            {
                [oldMemberCards removeObject:card];
            }
            
            card.cardName = [params stringValueForKey:@"name"];
            card.cardNo = [params stringValueForKey:@"no"];
            card.cardNumber = [params stringValueForKey:@"no"];
            card.cardUUID = [params stringValueForKey:@"born_uuid"];
            card.amount = [params stringValueForKey:@"amount"];
            card.balance = [params stringValueForKey:@"amount"];
            card.points = [params stringValueForKey:@"points"];
            card.courseRemainAmount = [params stringValueForKey:@"course_remain_amount"];
            card.giveAmount = [params stringValueForKey:@"give_amount"];
            card.arrearsAmount = [params stringValueForKey:@"arrears_amount"];//充值欠款
            card.courseArrearsAmount = [params stringValueForKey:@"course_arrears_amount"];//消费欠款
            card.captcha = [params stringValueForKey:@"captcha"];
            card.lastUpdate = [params stringValueForKey:@"write_date"];
            card.captcha = [params stringValueForKey:@"captcha"];
            card.invalidDate = [params stringValueForKey:@"invalid_date"];
            card.isInvalid = [NSNumber numberWithBool:[[params objectForKey:@"is_invalid"] boolValue]];
            card.default_code = [params stringValueForKey:@"default_code"];
            
            card.isActive = [NSNumber numberWithBool:NO];
            if ([state isEqualToString:@"active"])
            {
                card.isActive = [NSNumber numberWithBool:YES];
                card.state = [NSNumber numberWithInteger:kPadMemberCardStateActive];
            }
            else if ([state isEqualToString:@"draft"])
            {
                card.state = [NSNumber numberWithInteger:kPadMemberCardStateDraft];
            }
            else if ([state isEqualToString:@"lost"])
            {
                card.state = [NSNumber numberWithInteger:kPadMemberCardStateLost];
            }
            else if ([state isEqualToString:@"replacement"])
            {
                card.state = [NSNumber numberWithInteger:kPadMemberCardStateReplacement];
            }
            else if ([state isEqualToString:@"merger"])
            {
                card.state = [NSNumber numberWithInteger:kPadMemberCardStateMerger];
            }
            else if ([state isEqualToString:@"unlink"])
            {
                card.state = [NSNumber numberWithInteger:kPadMemberCardStateUnlink];
            }
            
            NSArray *shopIds = [params objectForKey:@"shop_id"];
            if ([shopIds isKindOfClass:[NSArray class]] && shopIds.count >= 1)
            {
                NSNumber *storeID = [shopIds objectAtIndex:0];
                CDStore *store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:storeID forKey:@"storeID"];
                if (store == nil)
                {
                    store = [[BSCoreDataManager currentManager] insertEntity:@"CDStore"];
                    store.storeID = storeID;
                }
                store.storeName = [shopIds objectAtIndex:1];
                card.store = store;
                card.storeID = storeID;
                card.storeName = [shopIds objectAtIndex:1];
            }
            
            NSArray *memberIDArray = [params arrayValueForKey:@"member_id"];
            if(memberIDArray.count > 1)
            {
                NSNumber *memberId = [memberIDArray objectAtIndex:0];
                CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:memberId forKey:@"memberID"];
                if(member == nil)
                {
                    member = [[BSCoreDataManager currentManager] insertEntity:@"CDMember"];
                    member.memberID = memberId;
                    member.memberName = [memberIDArray objectAtIndex:1];
                }
                card.member = member;
            }
            
            NSArray *priceList = [params arrayValueForKey:@"pricelist_id"];
            if (priceList.count > 0)
            {
                NSNumber *priceListId = priceList[0];
                CDMemberPriceList *price = [[BSCoreDataManager currentManager] findEntity:@"CDMemberPriceList" withValue:priceListId forKey:@"priceID"];
                if(!price)
                {
                    price = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberPriceList"];
                    price.priceID = priceListId;
                }
                price.name = priceList[1];
                card.priceList = price;
            }
            
            NSMutableOrderedSet *arrearsSet = [NSMutableOrderedSet orderedSet];
            NSMutableOrderedSet *projectSet = [NSMutableOrderedSet orderedSet];
            NSMutableOrderedSet *productSet = [NSMutableOrderedSet orderedSet];
            NSArray *arrearsIds = [params arrayValueForKey:@"arrears_ids"];
            for (int i = 0; i < arrearsIds.count; i++)
            {
                NSNumber *arrearsId = [arrearsIds objectAtIndex:i];
                CDMemberCardArrears *arrears = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCardArrears" withValue:arrearsId forKey:@"arrearsID"];
                if (arrears == nil)
                {
                    arrears = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCardArrears"];
                    arrears.arrearsID = arrearsId;
                }
                [arrearsSet addObject:arrears];
            }
            card.arrears = arrearsSet;
            
            //卡内项目
            NSArray *projects = [params arrayValueForKey:@"product_ids"];
            for (int i = 0; i < projects.count; i++)
            {
                NSNumber *productLineID = [projects objectAtIndex:i];
                CDMemberCardProject *project = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCardProject" withValue:productLineID forKey:@"productLineID"];
                if (project == nil)
                {
                    project = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCardProject"];
                    project.productLineID = productLineID;
                }
                [projectSet addObject:project];
            }
            card.projects = projectSet;
            if (self.type == kFetchMemberCardWithMemberCardIds)
            {
                [productArray addObjectsFromArray:projects];
            }
            
            //购买项目
            NSArray *products = [params arrayValueForKey:@"product_all_ids"];
            for (int i = 0; i < products.count; i++)
            {
                NSNumber *productLineID = [products objectAtIndex:i];
                CDMemberCardProject *product = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCardProject" withValue:productLineID forKey:@"productLineID"];
                if (product == nil)
                {
                    product = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCardProject"];
                    product.productLineID = productLineID;
                }
                [productSet addObject:product];
            }
            card.products = productSet;
            
            if (self.type == kFetchMemberCardWithMemberCardIds)
            {
                [productArray addObjectsFromArray:products];
            }
        }
        
        if (self.type == kFetchMemberCardWithMemberCardIds)
        {

            BSFetchMemberCardProjectRequest *request = [[BSFetchMemberCardProjectRequest alloc] initWithMemberCardProjectIds:productArray];
            [request execute];
        }
        
        [[BSCoreDataManager currentManager] deleteObjects:oldMemberCards];
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求发生错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberCardResponse object:nil userInfo:dict];
}

@end
