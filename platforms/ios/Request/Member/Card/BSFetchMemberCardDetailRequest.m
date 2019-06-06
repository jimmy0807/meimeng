//
//  BSFetchMemberCardDetailRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/11/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchMemberCardDetailRequest.h"
#import "BSFetchMemberCardArrearsRequest.h"
#import "BSFetchMemberCardProjectRequest.h"
#import "BSFetchCardPointsRequest.h"
#import "BSFetchCardConsumeRequest.h"
#import "BSFetchCardOperateRequest.h"
#import "BSFetchCardAmountsRequest.h"

@interface BSFetchMemberCardDetailRequest ()
@property (nonatomic, strong, nullable) NSNumber *memberCardID;
@property (nonatomic, strong) NSString *posCardNo;
@property (nonatomic, strong) NSString *cardNo;
@end

@implementation BSFetchMemberCardDetailRequest

- (id)initWithMemberCardID:(NSNumber *)memberCardID
{
    self = [super init];
    if (self)
    {
        self.memberCardID = memberCardID;
    }
    
    return self;
}

- (id)initWithPosCardNo:(NSString *)posCardNo
{
    self = [super init];
    if (self)
    {
        self.posCardNo = posCardNo;
    }
    
    return self;
}

- (id)initWithCardNo:(NSString *)cardNo
{
    self = [super init];
    if (self)
    {
        self.cardNo = cardNo;
    }
    
    return self;
}

- (BOOL)willStart
{
    if ( self.memberCardID == nil && self.posCardNo == nil )
        return FALSE;
    
    self.tableName = @"born.card";
    if ( self.posCardNo )
    {
        self.filter = @[@[@"default_code", @"=", self.posCardNo]];
    }
    else
    {
        self.filter = @[@[@"id", @"=", self.memberCardID]];
    }
    
    self.field = @[@"id", @"no", @"name", @"born_uuid", @"shop_id", @"amount", @"give_amount", @"arrears_amount", @"course_arrears_amount", @"state", @"captcha", @"invalid_date", @"member_id", @"pricelist_id", @"arrears_ids", @"product_ids", @"product_all_ids",@"consume_ids", @"operate_ids", @"statement_ids", @"point_ids", @"company_id", @"recharge_amount", @"product_consume_amount", @"item_consume_amount", @"password", @"points", @"is_sign", @"is_employee_card", @"is_share",@"is_invalid", @"course_remain_amount",@"default_code",@"use_start_time",@"use_end_time"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([resultArray isKindOfClass:[NSArray class]])
    {
        if ( resultArray.count == 0 )
        {
            if ( self.memberCardID )
            {
                CDMemberCard *card = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.memberCardID forKey:@"cardID"];
                [[BSCoreDataManager currentManager] deleteObject:card];
            }
            else if ( self.posCardNo )
            {
                CDMemberCard *card = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.posCardNo forKey:@"default_code"];
                [[BSCoreDataManager currentManager] deleteObject:card];
            }
        }
        else
        {
            for (NSDictionary *params in resultArray)
            {
                NSNumber *cardID = [params numberValueForKey:@"id"];
                CDMemberCard *card = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:cardID forKey:@"cardID"];
                if (card == nil)
                {
                    card = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCard"];
                    card.cardID = cardID;
                }
                
                card.use_start_time = [params stringValueForKey:@"use_start_time"];
                card.use_end_time = [params stringValueForKey:@"use_end_time"];
                
                card.cardName = [params stringValueForKey:@"name"];
                card.cardNo = [params stringValueForKey:@"no"];
                card.cardNumber = [params stringValueForKey:@"no"];
                card.cardUUID = [params stringValueForKey:@"born_uuid"];
                card.amount = [params stringValueForKey:@"amount"];
                card.balance = [params stringValueForKey:@"amount"];
                card.points = [params stringValueForKey:@"points"];
                card.giveAmount = [params stringValueForKey:@"give_amount"];
                card.courseRemainAmount = [params stringValueForKey:@"course_remain_amount"];
                card.courseArrearsAmount = [params stringValueForKey:@"course_arrears_amount"];
                card.captcha = [params stringValueForKey:@"captcha"];
                card.lastUpdate = [params stringValueForKey:@"write_date"];
                card.invalidDate = [params stringValueForKey:@"invalid_date"];
                card.arrearsAmount = [params stringValueForKey:@"arrears_amount"];  //充值欠款
                card.recharge_amount = [params stringValueForKey:@"recharge_amount"]; //累计充值金额
                card.item_consume_amount = [params stringValueForKey:@"item_consume_amount"];
                card.product_consume_amount = [params stringValueForKey:@"product_consume_amount"];
                card.is_sign = [params numberValueForKey:@"is_sign"];
                card.is_employee_card = [params numberValueForKey:@"is_employee_card"];
                card.is_share = [params numberValueForKey:@"is_share"];
                card.password = [params stringValueForKey:@"password"];
                card.default_code = [params stringValueForKey:@"default_code"];
                card.isInvalid = [NSNumber numberWithBool:[[params objectForKey:@"is_invalid"] boolValue]];
                NSString *state = [params stringValueForKey:@"state"];
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
                if(memberIDArray.count > 0)
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
                
                //九折卡等卡类型
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
                
                NSMutableOrderedSet *projectSet = [NSMutableOrderedSet orderedSet];
                NSMutableOrderedSet *productSet = [NSMutableOrderedSet orderedSet];
                NSMutableOrderedSet *consumeSet = [NSMutableOrderedSet orderedSet];
                NSMutableOrderedSet *pointSet = [NSMutableOrderedSet orderedSet];
                NSMutableOrderedSet *amountSet = [NSMutableOrderedSet orderedSet];
                NSMutableOrderedSet *operateSet = [NSMutableOrderedSet orderedSet];
                NSMutableOrderedSet *arrearsSet = [NSMutableOrderedSet orderedSet];
                
                //卡内项目明细
                NSArray *projects = [params arrayValueForKey:@"product_ids"];
                card.card_project_count = @(projects.count); //卡内项目个数
                
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
                
                //购买项目
                NSArray *products = [params arrayValueForKey:@"product_all_ids"];
                card.buy_project_count = @(products.count);
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
                
                
                NSInteger recordCount = 0;
                
                //operate_ids操作明细
                NSArray *operateIds = [params arrayValueForKey:@"operate_ids"];
                recordCount += operateIds.count;
                
                for (NSNumber *operateId in operateIds) {
                    CDPosOperate *operate = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDPosOperate" withValue:operateId forKey:@"operate_id"];
                    [operateSet addObject:operate];
                }
                
                card.operates = operateSet;
                
                
                //statement_ids金额变动明细
                NSArray *statementIds = [params arrayValueForKey:@"statement_ids"];
                recordCount += statementIds.count;
                
                for (NSNumber *amountId in statementIds) {
                    CDMemberCardAmount *amount = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMemberCardAmount" withValue:amountId forKey:@"amount_id"];
                    [amountSet addObject:amount];
                }
                card.amounts = amountSet;
                
                
                //arrears_ids欠款还款明细
                NSArray *arrearsIds = [params arrayValueForKey:@"arrears_ids"];
                recordCount += arrearsIds.count;
                
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
                
                
                //point_ids积分明细
                NSArray *pointIds = [params arrayValueForKey:@"point_ids" ];
                recordCount += pointIds.count;
                for (NSNumber *pointId in pointIds) {
                    CDMemberCardPoint *point = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMemberCardPoint" withValue:pointId forKey:@"point_id"];
                    [pointSet addObject:point];
                }
                card.card_points = pointSet;
                
                
                //consume_ids 消费明细
                NSArray *consumeIds = [params arrayValueForKey:@"consume_ids" ];
                recordCount += consumeIds.count;
                for (NSNumber *consumeId in consumeIds) {
                    CDMemberCardConsume *consume = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMemberCardConsume" withValue:consumeId forKey:@"consume_id"];
                    [consumeSet addObject:consume];
                }
                card.counsumes = consumeSet;
                
                if ( self.posCardNo )
                {
                    BSFetchMemberCardProjectRequest *projectRequest = [[BSFetchMemberCardProjectRequest alloc] initWithMemberCardID:cardID];
                    [projectRequest execute];
                }
                else
                {
                    BSFetchMemberCardProjectRequest *projectRequest = [[BSFetchMemberCardProjectRequest alloc] initWithMemberCardID:self.memberCardID];
                    [projectRequest execute];
                }
                
                BSFetchMemberCardArrearsRequest *arrearsRequest = [[BSFetchMemberCardArrearsRequest alloc] initWithMemberCardID:self.memberCardID];
                [arrearsRequest execute];
                
                //            BSFetchCardPointsRequest *pointRequest = [[BSFetchCardPointsRequest alloc] initWithCardID:self.memberCardID];
                //            [pointRequest execute];
                //            
                //            
                //            BSFetchCardAmountsRequest *amountRequest = [[BSFetchCardAmountsRequest alloc] initWithCardID:self.memberCardID];
                //            [amountRequest execute];
                //            
                //            BSFetchCardOperateRequest *operateRequest = [[BSFetchCardOperateRequest alloc] initWithCardID:self.memberCardID];
                //            [operateRequest execute];
                //            
                //            BSFetchCardConsumeRequest *consumeRequest = [[BSFetchCardConsumeRequest alloc] initWithCardID:self.memberCardID];
                //            [consumeRequest execute];
                
            }
        }
        
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求发生错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberCardDetailResponse object:nil userInfo:dict];
    
}

@end
