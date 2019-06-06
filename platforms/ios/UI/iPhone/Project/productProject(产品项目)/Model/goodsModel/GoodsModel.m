//
//  GoodsModel.m
//  Boss
//
//  Created by jiangfei on 16/6/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GoodsModel.h"
#import "CDProjectTemplate+CoreDataClass.h"
#import "CDProjectItem+CoreDataClass.h"
@implementation GoodsModel
-(instancetype)init
{
    self = [super init];
    self.maxNum = -1;
    return self;
}
+(NSMutableArray*)goodsModelArray:(NSMutableArray*)goodsArray withGoodsModel:(GoodsModel*)goodsmodel
{
    int i=0;
    NSMutableArray *tmpArray = [NSMutableArray array];
    if (goodsArray.count) {
        [tmpArray addObjectsFromArray:goodsArray];
    }
    if (goodsArray.count) {
        for (GoodsModel *gModel in goodsArray) {
            if ([gModel isEqual:goodsmodel]) {//该商品在数组中存在
                i++;
                gModel.num++;
                if (goodsmodel.goodsModelType == GoodsModel_Default) {//默认下才算钱，会员和优惠券不算钱
                    gModel.price = gModel.unitPrice * gModel.num;
                }
                
            }
            
        }
        if (i==0) {
            if (goodsmodel.goodsModelType == GoodsModel_Default) {//默认下才算钱，会员和优惠券不算钱
                goodsmodel.price = goodsmodel.unitPrice;
            }
            goodsmodel.num = 1;
            [tmpArray addObject:goodsmodel];
        }
    }else{
        goodsmodel.num = 1;
        [tmpArray addObject:goodsmodel];
    }
    return tmpArray;
}

@end
