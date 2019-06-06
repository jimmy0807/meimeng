//
//  GoodsModel.h
//  Boss
//
//  Created by jiangfei on 16/6/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum GoodsModelType
{
    GoodsModel_Default,    //普通状态
    GoodsModel_Coupon,     //优惠券
    GoodsModel_Vip,        //会员
}GoodsModelType;
@class CDProjectTemplate;
@class CDProjectItem;
@interface GoodsModel : NSObject
/**CDProjectTemplate */
@property (nonatomic,strong)CDProjectTemplate *tmplate;
/** CDProjectItem*/
@property (nonatomic,strong)CDProjectItem *item;
/**  该商品的总数量*/
@property (nonatomic,assign)NSInteger num;
/** 商品的最大数 maxNum*/
@property (nonatomic,assign)NSInteger maxNum;
/**  是否是卡内项目*/
@property (nonatomic,assign)BOOL isCardItem;
/**  是否是券内项目*/
@property (nonatomic,assign)BOOL isCoupon;
/**  该商品的总价格*/
@property (nonatomic,assign)CGFloat price;
/**  商品单价*/
@property (nonatomic,assign)CGFloat unitPrice;
/**  折扣*/
@property (nonatomic,assign)CGFloat discount;
/**  modelType*/
@property (nonatomic,assign)GoodsModelType goodsModelType;

//goodsArray:(GoodsModel)
+(NSMutableArray*)goodsModelArray:(NSMutableArray*)goodsArray withGoodsModel:(GoodsModel*)goodsmodel;
@end
