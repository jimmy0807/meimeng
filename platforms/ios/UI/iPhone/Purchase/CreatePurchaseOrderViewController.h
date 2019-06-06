//
//  CreatePurchaseOrderViewController.h
//  Boss
//
//  Created by lining on 15/6/16.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

#define kSelectedProviderResponse @"kSelectedProviderResponse"

typedef enum OrderType
{
    OrderType_create,
    OrderType_eidt,
    OrderType_confirm,
    OrderType_done
}OrderType;


typedef enum OrderSection
{
    OrderSection_one,
    OrderSection_two,
    OrderSection_num,
    OrderSection_three,
    
}OrderSection;

typedef enum SectionRowOne
{
    SectionRowOne_provider,
    SectionRowOne_warehouse,
    SectionRowOne_date,
    SectionRowOne_num,
    SectionRowOne_no,
    SectionRowOne_storage,
}SectionRowOne;


typedef enum SectionRowTwo
{
    SectionRowTwo_productList,
    SectionRowTwo_total,
    SectionRowTwo_num
}SectionRowTwo;


typedef enum SectionRowThree
{
    SectionRowThree_approve,
    SectionRowThree_num
}SectionRowThree;

@interface CreatePurchaseOrderViewController : ICCommonViewController

@property(nonatomic, assign) OrderType type;
@property(nonatomic, strong) CDPurchaseOrder *purchaseOrder;
@end
