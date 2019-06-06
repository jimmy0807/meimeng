//
//  BSFetchCouponCardProductRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/11/10.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchCouponCardProductRequest.h"
#import "BSFetchCouponCardRequest.h"

typedef enum kFetchCouponCardProductType
{
    kFetchCouponCardProductAll,
    kFetchCouponCardProductWithProductIds,
    kFetchCouponCardProductWithCouponId,
}kFetchCouponCardProductType;

@interface BSFetchCouponCardProductRequest ()

@property (nonatomic, strong) NSArray *productIds;
@property (nonatomic, assign) kFetchCouponCardProductType type;
@property (nonatomic, strong) NSNumber *couponId;

@end

@implementation BSFetchCouponCardProductRequest

- (id)init
{
    if (self = [super init])
    {
        self.type = kFetchCouponCardProductAll;
    }
    
    return self;
}

- (id)initWithCouponCardProductIds:(NSArray *)productIds
{
    if (self = [super init])
    {
        self.productIds = productIds;
        self.type = kFetchCouponCardProductWithProductIds;
    }
    
    return self;
}


- (id)initWithCouponCardId:(NSNumber *)couponId
{
    self = [super init];
    if (self) {
        self.couponId = couponId;
        self.type = kFetchCouponCardProductWithCouponId;
    }
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.coupon.product";
    if (self.type == kFetchCouponCardProductWithProductIds)
    {
        self.filter = @[@[@"id", @"in", self.productIds]];
    }
    else if (self.type == kFetchCouponCardProductWithCouponId)
    {
        self.filter = @[@[@"coupon_id",@"=",self.couponId]];
    }
    self.field = @[@"id", @"product_id", @"__last_update", @"price_unit", @"qty", @"remain_qty"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([resultArray isKindOfClass:[NSArray class]])
    {
        NSArray *productArray;
//        NSMutableArray *oldProductArray = [NSMutableArray array];
        if (self.type == kFetchCouponCardProductAll)
        {
            productArray = [[BSCoreDataManager currentManager] fetchAllCouponCardProduct];
            
        }
        else if (self.type == kFetchCouponCardProductWithProductIds)
        {
            productArray = [[BSCoreDataManager currentManager] fetchCouponCardProductsWithProductIds:self.productIds];
        }
        else if (self.type == kFetchCouponCardProductWithCouponId)
        {
            productArray = [[BSCoreDataManager currentManager] fetchAllCouponCardProductsWithCouponId:self.couponId];
        }
        NSMutableArray *oldProductArray = [NSMutableArray arrayWithArray:productArray];
        for (NSDictionary *params in resultArray)
        {
            NSNumber *productLineID = [params numberValueForKey:@"id"];
            CDCouponCardProduct *product = [[BSCoreDataManager currentManager] findEntity:@"CDCouponCardProduct" withValue:productLineID forKey:@"productLineID"];
            if (product == nil)
            {
                product = [[BSCoreDataManager currentManager] insertEntity:@"CDCouponCardProduct"];
                product.productLineID = productLineID;
            }
            else
            {
               [oldProductArray removeObject:product];
            }
            
            product.productName = [params stringValueForKey:@"name"];
            NSArray *productIds = [params arrayValueForKey:@"product_id"];
            if (productIds.count > 1)
            {
                product.productID = [NSNumber numberWithInteger:[[productIds objectAtIndex:0] integerValue]];
                product.productName = [productIds objectAtIndex:1];
            }
            
            CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:product.productID forKey:@"itemID"];
            if (item == nil)
            {
                item = [[BSCoreDataManager currentManager] insertEntity:@"CDProjectItem"];
                item.itemID = product.productID;
                item.itemName = product.productName;
                product.uomName = @"";
                product.defaultCode = @"";
            }
            else
            {
                product.uomID = item.uomID;
                product.uomName = item.uomName;
                product.defaultCode = item.defaultCode;
            }
            product.item = item;
            
            product.lastUpdate = [params stringValueForKey:@"__last_update"];
            //product.discount = [NSNumber numberWithFloat:[[params stringValueForKey:@"discount"] floatValue]];
            product.purchaseQty = [NSNumber numberWithInteger:[[params objectForKey:@"qty"] integerValue]];
            product.remainQty = [NSNumber numberWithInteger:[[params objectForKey:@"remain_qty"] integerValue]];
            product.unitPrice = [NSNumber numberWithDouble:[[params objectForKey:@"price_unit"] doubleValue]];
        }
        
        [[BSCoreDataManager currentManager] deleteObjects:oldProductArray];
        [[BSCoreDataManager currentManager] save:nil];
        
        if (self.type == kFetchCouponCardProductAll)
        {
            BSFetchCouponCardRequest  *request = [[BSFetchCouponCardRequest alloc] init];
            [request execute];
        }
    }
    else
    {
        dict = [self generateResponse:@"请求发生错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchCouponCardProductResponse object:nil userInfo:dict];
}

@end
