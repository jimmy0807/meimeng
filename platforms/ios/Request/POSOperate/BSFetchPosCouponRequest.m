//
//  BSFetchPosCouponRequest.m
//  Boss
//
//  Created by lining on 15/11/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchPosCouponRequest.h"
#import "BSFetchPosCouponProduct.h"

@interface BSFetchPosCouponRequest ()
@property (nonatomic, strong) CDPosOperate *operate;
@end

@implementation BSFetchPosCouponRequest
- (instancetype)initWithPosOperate:(CDPosOperate *)operate
{
    self = [super init];
    if (self) {
        self.operate = operate;
    }
    
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.coupon.consume";
    self.filter = @[@[@"operate_id",@"=",self.operate.operate_id]];
    self.field = @[];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *couponIds = [NSMutableArray array];
    if ([retArray isKindOfClass:[NSArray class]] && retArray.count > 0) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        if (self.operate.consumCoupons.count > 0) {
            [dataManager deleteObjects:self.operate.consumCoupons.array];
            self.operate.consumCoupons = nil;
        }
        NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
        for (NSDictionary *params in retArray) {
            CDPosCoupon *consumCoupon = [dataManager insertEntity:@"CDPosCoupon"];
            consumCoupon.coupon_id = [params arrayIDValueForKey:@"coupon_id"];
            consumCoupon.coupon_name = [params arrayNameValueForKey:@"coupon_id"];
            
            [couponIds addObject:consumCoupon.coupon_id];
            
            consumCoupon.coupon_no = [params stringValueForKey:@"no"];
            
            consumCoupon.consum_coupon_line_id = [params numberValueForKey:@"id"];
            
            NSArray *lines = [params arrayValueForKey:@"lines"];
            consumCoupon.consum_coupon_product_lines= [lines componentsJoinedByString:@","];
            
            NSMutableOrderedSet *productSet = [[NSMutableOrderedSet alloc] init];
            for (NSNumber *line_id in lines) {
                CDPosCouponProduct *couponProduct = [dataManager uniqueEntityForName:@"CDPosCouponProduct" withValue:line_id forKey:@"line_id"];
                [productSet addObject:couponProduct];
            }
            
            consumCoupon.products = productSet;
            
            consumCoupon.consume_money = [params numberValueForKey:@"consume_money"];
            consumCoupon.born_uuid = [params stringValueForKey:@"born_uuid"];
            consumCoupon.operate_id = [params arrayIDValueForKey:@"operate_id"];
            consumCoupon.operate_name = [params arrayNameValueForKey:@"operate_id"];
            consumCoupon.shop_id = [params arrayIDValueForKey:@"shop_id"];
            consumCoupon.shop_name = [params arrayNameValueForKey:@"shop_id"];
            
            [orderedSet addObject:consumCoupon];
            
            
            //取优惠券内项目
//            [[[BSFetchPosCouponProduct alloc] initWithCoupon:consumCoupon operate:self.operate] execute];
        }
        
        self.operate.consumCoupons = orderedSet;
        
        if (couponIds.count > 0) {
            //取优惠券内项目
            BSFetchPosCouponProduct *fetchCouponRequest = [[BSFetchPosCouponProduct alloc] init];
            fetchCouponRequest.couponIds = couponIds;
            fetchCouponRequest.operate = self.operate;
            [fetchCouponRequest execute];
        }
        
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPosCouponProductResponse object:nil userInfo:dict];
    }
}

@end
