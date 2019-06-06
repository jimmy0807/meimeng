//
//  productProjectMainController.h
//  Boss
//
//  Created by jiangfei on 16/5/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCategoryView.h"
typedef enum ProductControllerType
{
    ProductControllerType_Template,         //普通状态
    ProductControllerType_Sale,             //销售(有卡内项目)
    ProductControllerType_Buy,              //购买(没有卡内项目)
    ProductControllerType_Consume,          //添加消耗品
    ProductControllerType_SubItem,          //组合清单
    ProductControllerType_SameItem,         //可替换项目
    ProductControllerType_Import,           //导入会员卡项目
    ProductControllerType_Point,            //积分兑换
    
}ProductControllerType;


@interface ProductProjectMainController : ICCommonViewController

/** controller的类型 */
@property (nonatomic,assign)ProductControllerType controllerType;

/** 会员卡*/
@property (nonatomic,strong)CDMemberCard *card;

/** 优惠券*/
@property (nonatomic,strong)CDCouponCard *coupon;


//@property (nonatomic, strong)CDPosOperate *posOperate;


@property (nonatomic,assign)BOOL showBoomView;

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) NSArray *existsItemIds;

@property (strong, nonatomic) CDBornCategory *templateBornCategory;
@property (assign, nonatomic) BOOL isFromSuccessView;

@property (strong, nonatomic) NSMutableArray *consumeArray;
@property (strong, nonatomic) NSMutableArray *subItems;
@property (strong, nonatomic) NSMutableArray *sameItems;
@property (strong, nonatomic) NSMutableDictionary *sameSelectedItemDict;

@end
