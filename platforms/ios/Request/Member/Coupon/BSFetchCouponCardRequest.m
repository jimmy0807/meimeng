//
//  BSFetchCouponCardRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/11/10.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchCouponCardRequest.h"
#import "BSFetchCouponCardProductRequest.h"

typedef enum kFetchCouponCardType
{
    kFetchCouponCardAll,
    kFetchCouponCardWithCouponCardIds,
    kFetchCouponCardWithMemberId,
}kFetchCouponCardType;

@interface BSFetchCouponCardRequest ()

@property (nonatomic, strong) NSArray *couponCardIds;
@property (nonatomic, assign) kFetchCouponCardType type;
@property (nonatomic, strong) NSNumber *memberId;

@end

@implementation BSFetchCouponCardRequest

- (id)init
{
    self = [super init];
    if (self)
    {
        self.type = kFetchCouponCardAll;
    }
    
    return self;
}

- (id)initWithCouponCardIds:(NSArray *)couponCardIds
{
    if (self = [super init])
    {
        self.couponCardIds = couponCardIds;
        self.type = kFetchCouponCardWithCouponCardIds;
    }
    
    return self;
}

- (id)initWithMemberId:(NSNumber *)memberId
{
    self = [super init];
    if (self) {
        self.memberId = memberId;
        self.type = kFetchCouponCardWithMemberId;
    }
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.coupon";
    if (self.type == kFetchCouponCardWithCouponCardIds)
    {
        self.filter = @[@[@"id", @"in", self.couponCardIds]];
    }
    else if (self.type == kFetchCouponCardWithMemberId)
    {
        self.filter = @[@[@"member_id",@"=",self.memberId]];
    }
    self.field = @[@"id", @"name", @"no", @"amount", @"mobile", @"mobile_buy", @"need_share", @"password", @"price", @"discount", @"state", @"card_type", @"source_type", @"__last_update", @"is_invalid", @"invalid_date", @"published_date", @"is_push", @"note", @"remark",  @"remain_amount", @"course_remain_amount", @"course_remain_qty", @"member_id", @"company_id", @"shop_id", @"product_ids", @"consume_ids"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableArray *productArray = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]])
    {
        NSMutableArray *oldCouponCards = [NSMutableArray array];
        NSArray *couponCards;
        if (self.type == kFetchCouponCardAll)
        {
            couponCards = [[BSCoreDataManager currentManager] fetchAllCouponCard];
        }
        else if(self.type == kFetchCouponCardWithCouponCardIds)
        {
            couponCards = [[BSCoreDataManager currentManager] fetchCouponCardWithIds:self.couponCardIds];
        }
        else if (self.type == kFetchCouponCardWithMemberId)
        {
            couponCards = [[BSCoreDataManager currentManager] fetchCouponCardWithMemberId:self.memberId];
        }
        oldCouponCards = [NSMutableArray arrayWithArray:couponCards];
        for (NSDictionary *params in retArray)
        {
            NSNumber *cardID = [params numberValueForKey:@"id"];
            CDCouponCard *coupon = [[BSCoreDataManager currentManager] findEntity:@"CDCouponCard" withValue:cardID forKey:@"cardID"];
            if (coupon == nil)
            {
                coupon = [[BSCoreDataManager currentManager] insertEntity:@"CDCouponCard"];
                coupon.cardID = cardID;
            }
            else
            {
                 [oldCouponCards removeObject:coupon];
            }
            
            coupon.cardName = [params stringValueForKey:@"name"];
            coupon.cardNumber = [params stringValueForKey:@"no"];
            coupon.amount = [NSNumber numberWithDouble:[[params objectForKey:@"amount"] doubleValue]];
            coupon.phoneNumber = [params stringValueForKey:@"mobile"];
            coupon.buyMobile = [params stringValueForKey:@"mobile_buy"];
            coupon.password = [params stringValueForKey:@"password"];
            coupon.lastUpdate = [params stringValueForKey:@"__last_update"];
            NSString *state = [params stringValueForKey:@"state"];
            if ([state isEqualToString:@"draft"])
            {
                coupon.state = [NSNumber numberWithInteger:kPadCouponCardStateDraft];
            }
            else if ([state isEqualToString:@"published"])
            {
                coupon.state = [NSNumber numberWithInteger:kPadCouponCardStatePublished];
            }
            else if ([state isEqualToString:@"active"])
            {
                coupon.state = [NSNumber numberWithInteger:kPadCouponCardStateActive];
            }
            else if ([state isEqualToString:@"used"])
            {
                coupon.state = [NSNumber numberWithInteger:kPadCouponCardStateUsed];
            }
            else if ([state isEqualToString:@"invalid"])
            {
                coupon.state = [NSNumber numberWithInteger:kPadCouponCardStateInvalid];
            }
            else if ([state isEqualToString:@"unlink"])
            {
                coupon.state = [NSNumber numberWithInteger:kPadCouponCardStateUnlink];
            }
            
            coupon.cardType = [NSNumber numberWithInteger:[[params stringValueForKey:@"card_type"] integerValue]];
            coupon.sourceType = [NSNumber numberWithInteger:[[params stringValueForKey:@"source_type"] integerValue]];
            coupon.needShare = [NSNumber numberWithInteger:[[params objectForKey:@"need_share"] integerValue]];
            coupon.cardPrice = [NSNumber numberWithDouble:[[params objectForKey:@"price"] doubleValue]];
            coupon.discount = [NSNumber numberWithDouble:[[params objectForKey:@"discount"] doubleValue]];
            coupon.cardNote = [params stringValueForKey:@"note"];
            
            NSString *remarkstr = [[[NSAttributedString alloc] initWithData:[[params stringValueForKey:@"remark"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil] string];
            remarkstr = [remarkstr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            coupon.remark = remarkstr;
            
            coupon.remainAmount = [NSNumber numberWithDouble:[[params objectForKey:@"remain_amount"] doubleValue]];
            coupon.courseRemainAmount = [NSNumber numberWithDouble:[[params objectForKey:@"course_remain_amount"] doubleValue]];
            coupon.courseRemainQty = [NSNumber numberWithInteger:[[params objectForKey:@"course_remain_qty"] integerValue]];
            coupon.isInvalid = [NSNumber numberWithBool:[[params objectForKey:@"is_invalid"] boolValue]];
            coupon.invalidDate = [params stringValueForKey:@"invalid_date"];
            coupon.isPush = [NSNumber numberWithBool:[[params objectForKey:@"is_push"] boolValue]];
            coupon.publishedDate = [params stringValueForKey:@"published_date"];
            NSArray *memberIds = [params arrayValueForKey:@"member_id"];
            if (memberIds.count > 1)
            {
                coupon.memberID = [NSNumber numberWithInteger:[[memberIds objectAtIndex:0] integerValue]];
                coupon.memberName = [memberIds objectAtIndex:1];
                CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:coupon.memberID forKey:@"memberID"];
                if (member == nil)
                {
                    member = [[BSCoreDataManager currentManager] insertEntity:@"CDMember"];
                    member.memberID = coupon.memberID;
                    member.memberName = coupon.memberName;
                }
                coupon.member = member;
            }
            
            NSArray *companyIds = [params arrayValueForKey:@"company_id"];
            if (companyIds.count > 1)
            {
                coupon.companyID = [NSNumber numberWithInteger:[[companyIds objectAtIndex:0] integerValue]];
                coupon.companyName = [companyIds objectAtIndex:1];
            }
            
            NSArray *storeIds = [params arrayValueForKey:@"shop_id"];
            if (storeIds.count > 1)
            {
                coupon.storeID = [NSNumber numberWithInteger:[[storeIds objectAtIndex:0] integerValue]];
                coupon.storeName = [storeIds objectAtIndex:1];
            }
            
            NSMutableOrderedSet *productSet = [NSMutableOrderedSet orderedSet];
            NSArray *products = [params arrayValueForKey:@"product_ids"];
            for (int i = 0; i < products.count; i++)
            {
                NSNumber *productLineID = [products objectAtIndex:i];
                CDCouponCardProduct *product = [[BSCoreDataManager currentManager] findEntity:@"CDCouponCardProduct" withValue:productLineID forKey:@"productLineID"];
                if (product == nil)
                {
                    product = [[BSCoreDataManager currentManager] insertEntity:@"CDCouponCardProduct"];
                    product.productLineID = productLineID;
                }
                [productSet addObject:product];
            }
            coupon.products = productSet;
            
            if (self.type == kFetchCouponCardWithCouponCardIds)
            {
                [productArray addObjectsFromArray:products];
            }
        }
        
        if (self.type == kFetchCouponCardWithCouponCardIds)
        {
            if (productArray.count > 0) {
                BSFetchCouponCardProductRequest *request = [[BSFetchCouponCardProductRequest alloc] initWithCouponCardProductIds:productArray];
                [request execute];
            }
        }
        
        [[BSCoreDataManager currentManager] deleteObjects:oldCouponCards];
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求发生错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchCouponCardResponse object:nil userInfo:dict];
}

@end
