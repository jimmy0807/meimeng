//
//  BSFetchPosCoupanProduct.m
//  Boss
//
//  Created by lining on 15/11/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchPosCouponProduct.h"
#import "BSFetchPosProductCategoryRequest.h"


@interface BSFetchPosCouponProduct ()
@property (strong, nonatomic) CDPosCoupon *consumCoupon;

@end

@implementation BSFetchPosCouponProduct


- (BOOL)willStart
{
    [super willStart];
    
    self.tableName = @"born.coupon.consume.line";
    if (self.couponIds.count > 0) {
//        self.filter = @[@[@"coupon_id",@"in",self.couponIds]];
    }
    if (self.operate) {
        self.filter = @[@[@"operate_id",@"=",self.operate.operate_id]];
    }
    self.field = @[];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *productIds = [NSMutableArray array];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        if (self.consumCoupon.products.count > 0) {
            [dataManager deleteObjects:self.consumCoupon.products.array];
            self.consumCoupon.products = nil;
        }
        NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
        for (NSDictionary *params in retArray) {
            CDPosCouponProduct *couponProduct = [dataManager insertEntity:@"CDPosCouponProduct"];
            couponProduct.line_id = [params numberValueForKey:@"id"];
            couponProduct.product_id = [params arrayIDValueForKey:@"product_id"];
            couponProduct.product_name = [params arrayNameValueForKey:@"product_id"];
            [productIds addObject:couponProduct.product_id];
            
            couponProduct.lastUpdate = [params stringValueForKey:@"__last_update"];
            couponProduct.product_qty = [params numberValueForKey:@"consume_qty"];
            
            couponProduct.product = [dataManager findEntity:@"CDProjectItem" withValue:couponProduct.product_id forKey:@"itemID"];
//            [productIds add]
//            couponProduct.coupon = self.consumCoupon;
          
            couponProduct.operate = self.operate;
            [orderedSet addObject:couponProduct];
        }
        self.consumCoupon.products = orderedSet;
        if (!IS_IPAD && productIds.count > 0) {
            BSFetchPosProductCategoryRequest *request = [[BSFetchPosProductCategoryRequest alloc] init];
            request.fetchProductIDs = productIds;
            [request execute];
        }
        
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    
     [[NSNotificationCenter defaultCenter] postNotificationName:kPosCouponProductResponse object:nil userInfo:dict];
    
}

@end
