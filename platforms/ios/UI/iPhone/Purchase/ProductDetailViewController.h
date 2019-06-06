//
//  ProductDetailViewController.h
//  Boss
//
//  Created by lining on 15/6/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum OrderLine_type
{
    OrderLine_type_create,
    OrderLine_type_edit,
}OrderLine_type;

@protocol ProductSelectedDelegate <NSObject>
- (void)didSelectedProduct:(CDProjectItem *)item;
@end

@interface ProductDetailViewController : ICCommonViewController
@property(nonatomic, strong) CDProjectItem *item;
@property(nonatomic, strong) CDPurchaseOrderLine *orderLine;
@property(nonatomic, assign) OrderLine_type type;
@end
